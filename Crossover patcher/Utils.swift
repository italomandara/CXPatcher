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
let LIB_PATH = "/lib/"
let EXTERNAL_FRAMEWORK_PATH = "/lib/external"
let EXTERNAL_WINE_PATHS: [String] = [
    "/lib/wine/x86_64-unix/atidxx64.so",
    "/lib/wine/x86_64-unix/d3d9.so",
    "/lib/wine/x86_64-unix/d3d10.so",
    "/lib/wine/x86_64-unix/d3d11.so",
    "/lib/wine/x86_64-unix/d3d12.so",
    "/lib/wine/x86_64-unix/dxgi.so",
    "/lib/wine/x86_64-windows/atidxx64.dll",
    "/lib/wine/x86_64-windows/d3d9.dll",
    "/lib/wine/x86_64-windows/d3d10.dll",
    "/lib/wine/x86_64-windows/d3d11.dll",
    "/lib/wine/x86_64-windows/d3d12.dll",
    "/lib/wine/x86_64-windows/dxgi.dll",
]

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
            "x86_64-unix/winemac.drv.so",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-unix/winemac.drv.so",
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
        (
            "x86_64-windows/winemac.drv",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-windows/winemac.drv",
            nil
        ),
        (
            "wine64-preloader",
            url.path + SHARED_SUPPORT_PATH + "/CrossOver-Hosted Application/wine64-preloader",
            nil
        ),
    ]
}

private func getExternalResourcesList(fromUrl: URL, toUrl: URL) -> [(String, String)]{
    return EXTERNAL_WINE_PATHS.map { path in
        (
            fromUrl.path + path,
            toUrl.path + SHARED_SUPPORT_PATH + path
        )
    }
}

private func maybeExt(_ ext: String?) -> String {
    return ext != nil ? "." + ext! : ""
}

private func  getBackupListFrom(url: URL) -> [String] {
    let externalRes = EXTERNAL_WINE_PATHS.map { path in
        url.path + "_orig" + SHARED_SUPPORT_PATH + path
    }
    let internalRes = getResourcesListFrom(url: url).map { (_, path, ext) in
        path + "_orig" + maybeExt(ext)
    }
    return internalRes + externalRes
}

private func safeResCopy(res: String, dest: String, ext: String? = nil) {
    print("moving \(dest + maybeExt(ext))")
    if(f.fileExists(atPath: dest + maybeExt(ext))) {
        do {try f.moveItem(atPath: dest + maybeExt(ext), toPath: dest + "_orig" + maybeExt(ext))
        } catch {
            print("\(dest + maybeExt(ext)) does not exist!")
        }
    } else {
        print("unexpected error")
    }
    if let sourceUrl = Bundle.main.url(forResource: res, withExtension: ext) {
        do { try f.copyItem(at: sourceUrl, to: URL(filePath: dest + maybeExt(ext)))
            print("\(res) copied")
        } catch {
            print(error)
        }
    }
}

private func safeFileCopy(source: String, dest: String, ext: String? = nil) {
    print("moving \(dest + maybeExt(ext))")
    if(f.fileExists(atPath: dest + maybeExt(ext))) {
        do {try f.moveItem(atPath: dest + maybeExt(ext), toPath: dest + "_orig" + maybeExt(ext))
        } catch {
            print("\(dest + maybeExt(ext)) does not exist!")
        }
    } else {
        print("unexpected error")
    }

    do { try f.copyItem(at: URL(filePath: source), to: URL(filePath: dest + maybeExt(ext)))
        print("\(source) copied")
    } catch {
        print(error)
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
        if (plist.CFBundleIdentifier == "com.codeweavers.CrossOver" && plist.CFBundleShortVersionString.starts(with: "22") ) {
            print("app version is ok: \(plist.CFBundleShortVersionString)")
            return true
        }
    }
    return false
}

struct FileDropDelegate: DropDelegate {
    @Binding var externalUrl: URL?
    @Binding var status: Status
    @Binding var skipVersionCheck: Bool
    @Binding var repatch: Bool
    
    func performDrop(info: DropInfo) -> Bool {
        if let item = info.itemProviders(for: [.fileURL]).first {
            let _ = item.loadObject(ofClass: URL.self) { object, error in
                if let url = object {
                    if(repatch && restoreApp(url: url)) {
                        print("Restoring first...")
                    }
                    applyPatch(url: url, status: &status, externalUrl: externalUrl, skipVersionCheck: skipVersionCheck)
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

func patch(url: URL, externalUrl: URL? = nil) {
    let resources = getResourcesListFrom(url: url)
    if(externalUrl != nil) {
        let at = URL(filePath: externalUrl!.path + EXTERNAL_FRAMEWORK_PATH)
        let to = URL(filePath: url.path + SHARED_SUPPORT_PATH + EXTERNAL_FRAMEWORK_PATH)
        print(at.path)
        print(to.path)
        do { try f.copyItem(at: at, to: to)
            print("\(at.path) copied")
        } catch {
            print(error)
            return
        }
        let externalResources = getExternalResourcesList(fromUrl: externalUrl!, toUrl: url)
        externalResources.forEach { resource in
            safeFileCopy(source: resource.0, dest: resource.1)
        }
    }
    resources.forEach { resource in
        safeResCopy(res: resource.0, dest: resource.1, ext: resource.2)
    }
}

func applyPatch(url: URL, status: inout Status, externalUrl: URL? = nil, skipVersionCheck: Bool? = nil) {
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
    if (externalUrl != nil){
        patch(url: url, externalUrl: externalUrl)
        status = .success
    } else {
        print("Error: no input external folder given")
    }
    return
}

func restoreApp(url: URL) -> Bool {
    if(!isAlreadyPatched(url: url) || !isCrossoverApp(url: url)) {
        print("it' s not crossover.app or it's not patched")
        return false
    }
    let filesToRestore = getResourcesListFrom(url: url)
    let externalFilesToRestore = getExternalResourcesList(fromUrl: url, toUrl: url)
    externalFilesToRestore.forEach { file in
        restoreFile(dest: file.1, ext: nil)
    }
    filesToRestore.forEach { file in
        restoreFile(dest: file.1, ext: file.2)
    }
    return true
}
