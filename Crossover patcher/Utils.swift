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
}

var f = FileManager()
let DEST_ROOT = "/Contents/SharedSupport/CrossOver"

private func safeResCopy(res: String, dest: String, ext: String? = nil) {
    let maybeExt = ext != nil ? "." + ext! : ""
    print("moving \(dest + maybeExt)")
    if(f.fileExists(atPath: dest + maybeExt )) {
        do {try f.moveItem(atPath: dest + maybeExt, toPath: dest + "_orig" + maybeExt)
        } catch {
            print("unexpected error")
        }
    }
    if let sourceUrl = Bundle.main.url(forResource: res, withExtension: ext) {
        do { try f.copyItem(at: sourceUrl, to: URL(filePath: dest + maybeExt))
            print("\(res) copied")
        } catch {
            print(error)
        }
    }
}

private func isAlreadyPatched(url: URL) -> Bool {
    let origMVKPath = url.path + DEST_ROOT + "/lib64/libMoltenVK_orig.dylib"
    let orig64dxvkPath = url.path + DEST_ROOT + "/lib64/wine/dxvk_orig"
    let orig32dxvkPath = url.path + DEST_ROOT + "/lib/wine/dxvk_orig"
    if (f.fileExists(atPath: origMVKPath) ||
        f.fileExists(atPath: orig64dxvkPath) ||
        f.fileExists(atPath: orig32dxvkPath)
    ) {
        return true
    }
    return false
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

private func isCrossoverApp(url: URL, version: String? = nil) -> Bool {
    let plistPath = url.path + "/Contents/info.plist"
    let destMVKPath = url.path + DEST_ROOT + "/lib64/libMoltenVK.dylib"
    let dest64dxvkPath = url.path + DEST_ROOT + "/lib64/wine/dxvk"
    let dest32dxvkPath = url.path + DEST_ROOT + "/lib/wine/dxvk"
    if (f.fileExists(atPath: url.path + DEST_ROOT) &&
        f.fileExists(atPath: destMVKPath) &&
        f.fileExists(atPath: dest64dxvkPath) &&
        f.fileExists(atPath: dest32dxvkPath) &&
        f.fileExists(atPath: plistPath)
    ) {
        let plist = parseCXPlist(plistPath: plistPath)
        if (plist.CFBundleIdentifier == "com.codeweavers.CrossOver" && plist.CFBundleShortVersionString == "22.1.1") {
            print("app version is ok: \(plist.CFBundleShortVersionString)")
            return true
        }
    }
    return false
}

func applyPatch(url: URL, status: inout Status) {
    if(!isCrossoverApp(url: url)) {
        print("it' s not crossover.app")
        status = .unpatched
        return
    }
    if (isAlreadyPatched(url: url)) {
        print("App is already patched")
        status = .alreadyPatched
        return
    }
    print("it's a crossover app")
    let destMVKPath = url.path + DEST_ROOT + "/lib64/libMoltenVK"
    let dest64dxvkPath = url.path + DEST_ROOT + "/lib64/wine/dxvk"
    let dest32dxvkPath = url.path + DEST_ROOT + "/lib/wine/dxvk"
    safeResCopy(res: "libMoltenVK", dest: destMVKPath, ext: "dylib")
    safeResCopy(res: "64", dest: dest64dxvkPath)
    safeResCopy(res: "32", dest: dest32dxvkPath)
    status = .success
    return
}

struct FileDropDelegate: DropDelegate {
    @Binding var status: Status
    
    func performDrop(info: DropInfo) -> Bool {
        if let item = info.itemProviders(for: [.fileURL]).first {
            let _ = item.loadObject(ofClass: URL.self) { object, error in
                if let url = object {
                    applyPatch(url: url, status: &status)
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
    }
}

func getTextBy(status: Status) -> String {
    switch status {
    case .unpatched:
        return "Drop your Crossover app Here"
    case .success:
        return "Your App is Updated"
    case .alreadyPatched:
        return "Your App has been already been patched"
    }
}
