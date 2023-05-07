//
//  Utils.swift
//  Crossover patcher
//
//  Created by Italo Mandara on 03/04/2023.
//

import Foundation
import SwiftUI

enum Status {
    case alreadyPatched
    case success
    case unpatched
    case error
}

var f = FileManager()
let SHARED_SUPPORT_PATH = "/Contents/SharedSupport/CrossOver"

private func getResourcesListFrom(url: URL) -> [(String, String, String?)]{
    return [
        (
            "libMoltenVK",
            url.path + SHARED_SUPPORT_PATH + "/lib64/libMoltenVK",
            "dylib"
        ),
        (
            "64",
            url.path + SHARED_SUPPORT_PATH + "/lib64/wine/dxvk",
            nil
        ),
        (
            "32",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/dxvk",
            nil
        ),
        (
            "x86_32on64-unix/ntdll.so",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_32on64-unix/ntdll.so",
            nil
        ),
        (
            "x86_64-unix/ntdll.so",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-unix/ntdll.so",
            nil
        ),
        (
            "i386-windows/ntdll.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/i386-windows/ntdll.dll",
            nil
        ),
        (
            "x86_64-windows/ntdll.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-windows/ntdll.dll",
            nil
        ),
    ]
}

private func maybeExt(_ ext: String?) -> String {
    return ext != nil ? "." + ext! : ""
}

private func  getBackupListFrom(url: URL) -> [String] {
    return getResourcesListFrom(url: url).map { (_, path, ext) in
        path + "_orig" + maybeExt(ext)
    }
}

private func safeResCopy(res: String, dest: String, ext: String? = nil) {
    print("moving \(dest + maybeExt(ext))")
    if(f.fileExists(atPath: dest + maybeExt(ext))) {
        do {try f.moveItem(atPath: dest + maybeExt(ext), toPath: dest + "_orig" + maybeExt(ext))
        } catch {
            print("unexpected error")
        }
    }
    if let sourceUrl = Bundle.main.url(forResource: res, withExtension: ext) {
        do { try f.copyItem(at: sourceUrl, to: URL(filePath: dest + maybeExt(ext)))
            print("\(res) copied")
        } catch {
            print(error)
        }
    }
}

private func restoreFile(dest: String, ext: String? = nil) {
    if(f.fileExists(atPath: dest + maybeExt(ext) )) {
        do {try f.removeItem(atPath: dest + maybeExt(ext))
            print("deleting \(dest)")
        } catch {
            print("can't delete file doesn't exist")
        }
    }
    if(f.fileExists(atPath: dest + "_orig" + maybeExt(ext) )) {
        do {try f.moveItem(atPath: dest + "_orig" + maybeExt(ext), toPath: dest + maybeExt(ext))
            print("copying \(dest)")
        } catch {
            print("can't move file doesn't exist")
        }
    }
}

func isAlreadyPatched(url: URL) -> Bool {
    let filesToCheck = getBackupListFrom(url: url)
    print(filesToCheck)
    return filesToCheck.contains { path in
        return f.fileExists(atPath: path)
    }
}

struct CXPlist: Decodable {
    private enum CodingKeys: String, CodingKey {
        case CFBundleIdentifier, CFBundleShortVersionString
    }

    let CFBundleIdentifier: String
    let CFBundleShortVersionString: String
}

func parseCXPlist(plistPath: String) -> CXPlist {
    let data = try! Data(contentsOf: URL(filePath: plistPath))
    let decoder = PropertyListDecoder()
    return try! decoder.decode(CXPlist.self, from: data)
}

func isCrossoverApp(url: URL, version: String? = nil, skipVersionCheck: Bool? = false) -> Bool {
    let plistPath = url.path + "/Contents/info.plist"
    if (f.fileExists(atPath: plistPath)) {
        let plist = parseCXPlist(plistPath: plistPath)
        if (plist.CFBundleIdentifier == "com.codeweavers.CrossOver" && skipVersionCheck == true) {
            return true
        }
        if (plist.CFBundleIdentifier == "com.codeweavers.CrossOver" && plist.CFBundleShortVersionString.starts(with: "22.1.1") ) {
            print("app version is ok: \(plist.CFBundleShortVersionString)")
            return true
        }
    }
    return false
}

struct FileDropDelegate: DropDelegate {
    @Binding var status: Status
    @Binding var skipVersionCheck: Bool
    
    func performDrop(info: DropInfo) -> Bool {
        if let item = info.itemProviders(for: [.fileURL]).first {
            let _ = item.loadObject(ofClass: URL.self) { object, error in
                if let url = object {
                    applyPatch(url: url, status: &status, skipVersionCheck: skipVersionCheck)
                }
            }
        } else {
            return false
        }
        return true
    }
}

func getColorBy(status: Status) -> Color {
    switch status {
    case .unpatched:
        return .gray
    case .success:
        return .green
    case .alreadyPatched:
        return .orange
    case .error:
        return .red
    }
}

func getTextBy(status: Status) -> String {
    switch status {
    case .error:
        return "Can't patch this app, please check your app version and make sure it's Crossover.app"
    case .unpatched:
        return "Drop your Crossover app Here"
    case .success:
        return "Your App is Updated"
    case .alreadyPatched:
        return "Your App has already been patched"
    }
}

func patch(url: URL) {
    let resources = getResourcesListFrom(url: url)
    resources.forEach {
        safeResCopy(res: $0.0, dest: $0.1, ext: $0.2)
    }
}

func applyPatch(url: URL, status: inout Status, skipVersionCheck: Bool? = nil) {
    if (isAlreadyPatched(url: url)) {
        print("App is already patched")
        status = .alreadyPatched
        return
    }
    if(!isCrossoverApp(url: url, skipVersionCheck: skipVersionCheck)) {
        print("it' s not crossover.app")
        status = .error
        return
    }
    print("it's a crossover app")
    patch(url: url)
    status = .success
    return
}

func restoreApp(url: URL) -> Bool {
    if(!isAlreadyPatched(url: url) && !isCrossoverApp(url: url)) {
        print("it' s not crossover.app or it's not patched")
        return false
    }
    let filesToRestore = getResourcesListFrom(url: url)
    filesToRestore.forEach {
        restoreFile(dest: $0.1, ext: $0.2)
    }
    return true
}
