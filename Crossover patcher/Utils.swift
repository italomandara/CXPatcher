//
//  Utils.swift
//  Crossover patcher
//
//  Created by Italo Mandara on 03/04/2023.
//

var isVentura: Bool {
    SKIP_VENTURA_CHECK ? false : ProcessInfo().operatingSystemVersion.majorVersion < 14
}

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
            "x86_32on64-unix/crypt32.so",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_32on64-unix/crypt32.so",
            nil
        ),
        (
            "x86_32on64-unix/ntdll.so",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_32on64-unix/ntdll.so",
            nil
        ),
        (
            "x86_32on64-unix/qcap.so",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_32on64-unix/qcap.so",
            nil
        ),
        (
            "x86_32on64-unix/winegstreamer.so",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_32on64-unix/winegstreamer.so",
            nil
        ),
        (
            "x86_64-unix/crypt32.so",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-unix/crypt32.so",
            nil
        ),
        (
            "x86_64-unix/ntdll.so",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-unix/ntdll.so",
            nil
        ),
        (
            "x86_64-unix/qcap.so",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-unix/qcap.so",
            nil
        ),
        (
            "x86_64-unix/winegstreamer.so",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-unix/winegstreamer.so",
            nil
        ),
        (
            "x86_64-unix/winemac.drv.so",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-unix/winemac.drv.so",
            nil
        ),
        (
            "i386-windows/advapi32.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/i386-windows/advapi32.dll",
            nil
        ),
        (
            "i386-windows/api-ms-win-core-psm-appnotify-l1-1-0.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/i386-windows/api-ms-win-core-psm-appnotify-l1-1-0.dll",
            nil
        ),
        (
            "i386-windows/api-ms-win-power-base-l1-1-0.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/i386-windows/api-ms-win-power-base-l1-1-0.dll",
            nil
        ),
        (
            "i386-windows/atiadlxx.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/i386-windows/atiadlxx.dll",
            nil
        ),
        (
            "i386-windows/crypt32.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/i386-windows/crypt32.dll",
            nil
        ),
        (
            "i386-windows/kernel32.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/i386-windows/kernel32.dll",
            nil
        ),
        (
            "i386-windows/kernelbase.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/i386-windows/kernelbase.dll",
            nil
        ),
        (
            "i386-windows/mfmediaengine.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/i386-windows/mfmediaengine.dll",
            nil
        ),
        (
            "i386-windows/mfplat.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/i386-windows/mfplat.dll",
            nil
        ),
        (
            "i386-windows/mfreadwrite.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/i386-windows/mfreadwrite.dll",
            nil
        ),
        (
            "i386-windows/ntdll.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/i386-windows/ntdll.dll",
            nil
        ),
        (
            "i386-windows/qcap.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/i386-windows/qcap.dll",
            nil
        ),
        (
            "i386-windows/quartz.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/i386-windows/quartz.dll",
            nil
        ),
        (
            "i386-windows/windows.gaming.input.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/i386-windows/windows.gaming.input.dll",
            nil
        ),
        (
            "i386-windows/windows.gaming.ui.gamebar.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/i386-windows/windows.gaming.ui.gamebar.dll",
            nil
        ),
        (
            "i386-windows/wined3d.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/i386-windows/wined3d.dll",
            nil
        ),
        (
            "i386-windows/winegstreamer.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/i386-windows/winegstreamer.dll",
            nil
        ),
        (
            "i386-windows/wintrust.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/i386-windows/wintrust.dll",
            nil
        ),
        (
            "x86_64-windows/advapi32.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-windows/advapi32.dll",
            nil
        ),
        (
            "x86_64-windows/api-ms-win-core-psm-appnotify-l1-1-0.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-windows/api-ms-win-core-psm-appnotify-l1-1-0.dll",
            nil
        ),
        (
            "x86_64-windows/api-ms-win-power-base-l1-1-0.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-windows/api-ms-win-power-base-l1-1-0.dll",
            nil
        ),
        (
            "x86_64-windows/atiadlxx.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-windows/atiadlxx.dll",
            nil
        ),
        (
            "x86_64-windows/crypt32.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-windows/crypt32.dll",
            nil
        ),
        (
            "x86_64-windows/kernel32.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-windows/kernel32.dll",
            nil
        ),
        (
            "x86_64-windows/kernelbase.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-windows/kernelbase.dll",
            nil
        ),
        (
            "x86_64-windows/mfmediaengine.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-windows/mfmediaengine.dll",
            nil
        ),
        (
            "x86_64-windows/mfplat.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-windows/mfplat.dll",
            nil
        ),
        (
            "x86_64-windows/mfreadwrite.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-windows/mfreadwrite.dll",
            nil
        ),
        (
            "x86_64-windows/ntdll.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-windows/ntdll.dll",
            nil
        ),
        (
            "x86_64-windows/qcap.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-windows/qcap.dll",
            nil
        ),
        (
            "x86_64-windows/quartz.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-windows/quartz.dll",
            nil
        ),
        (
            "x86_64-windows/windows.gaming.input.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-windows/windows.gaming.input.dll",
            nil
        ),
        (
            "x86_64-windows/windows.gaming.ui.gamebar.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-windows/windows.gaming.ui.gamebar.dll",
            nil
        ),
        (
            "x86_64-windows/wined3d.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-windows/wined3d.dll",
            nil
        ),
        (
            "x86_64-windows/winegstreamer.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-windows/winegstreamer.dll",
            nil
        ),
        (
            "x86_64-windows/winemac.drv",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-windows/winemac.drv",
            nil
        ),
        (
            "x86_64-windows/wintrust.dll",
            url.path + SHARED_SUPPORT_PATH + "/lib/wine/x86_64-windows/wintrust.dll",
            nil
        ),
        (
            "wine64-preloader",
            url.path + SHARED_SUPPORT_PATH + "/CrossOver-Hosted Application/wine64-preloader",
            nil
        ),
        (
            "crossover.inf",
            url.path + SHARED_SUPPORT_PATH + "/share/crossover/bottle_data/crossover.inf",
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
    let internalRes = getResourcesListFrom(url: url).map { (_, path, ext) in
        path + "_orig" + maybeExt(ext)
    }
    return internalRes
}

private func  getExternalBackupListFrom(url: URL) -> [String] {
    let externalRes = EXTERNAL_WINE_PATHS.map { path in
        url.path + "_orig" + SHARED_SUPPORT_PATH + path
    }
    return externalRes
}

private func safeResCopy(res: String, dest: String, ext: String? = nil) {
//    print("moving \(dest + maybeExt(ext))")
    if(f.fileExists(atPath: dest + maybeExt(ext))) {
        do {try f.moveItem(atPath: dest + maybeExt(ext), toPath: dest + "_orig" + maybeExt(ext))
        } catch {
            print("\(dest + maybeExt(ext)) does not exist!")
        }
    } else {
        print("unexpected error: \(dest + maybeExt(ext)) doesn't have an original copy will just copy then")
    }
    if let sourceUrl = Bundle.main.url(forResource: res, withExtension: ext) {
        do { try f.copyItem(at: sourceUrl, to: URL(filePath: dest + maybeExt(ext)))
            print("\(res) copied")
        } catch {
            print(error)
        }
    } else {
        print("\(res) not found")
    }
}

private func safeFileCopy(source: String, dest: String, ext: String? = nil) {
//    print("moving \(dest + maybeExt(ext))")
    if(f.fileExists(atPath: dest + maybeExt(ext))) {
        do {try f.moveItem(atPath: dest + maybeExt(ext), toPath: dest + "_orig" + maybeExt(ext))
        } catch {
            print("\(dest + maybeExt(ext)) does not exist!")
        }
    } else {
        print("file doesn't exist I'll just copy then")
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
            print("can't delete file \(dest)")
        }
    } else {
        print("file \(dest) doesn't exist... ignoring and deleting just _orig if found")
    }
    if(f.fileExists(atPath: dest + "_orig" + maybeExt(ext) )) {
        do {try f.moveItem(atPath: dest + "_orig" + maybeExt(ext), toPath: dest + maybeExt(ext))
            print("copying \(dest)")
        } catch {
            print("can't move file \(dest)")
        }
    } else {
        print("file \(dest) doesn't exist... ignoring")
    }
}

func isAlreadyPatched(url: URL) -> Bool {
    let filesToCheck = getBackupListFrom(url: url)
//    print(filesToCheck)
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
    print("file doesn't exist at \(plistPath)")
    return false
}

func isGStreamerInstalled() -> Bool {
    if(f.fileExists(atPath: "/Library/Frameworks/GStreamer.framework")) {
        return true
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
                    restoreAndPatch(repatch: repatch, url: url, status: &status, externalUrl: externalUrl, skipVersionCheck: skipVersionCheck)
                }
            }
        } else {
            return false
        }
        return true
    }
}

func openAppSelectorPanel() -> URL? {
    let panel = NSOpenPanel()
    panel.title = "Select the CrossOver app";
    panel.allowsMultipleSelection = false;
    panel.canChooseDirectories = false;
    panel.allowedContentTypes = [.application]
    return panel.runModal() == .OK ? panel.url?.absoluteURL : nil
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

func getIconBy(status: Status) -> String {
    switch status {
    case .unpatched:
        return "plus.app"
    case .success:
        return "checkmark.circle.fill"
    case .alreadyPatched:
        return "hand.raised.app.fill"
    case .error:
        return "x.circle.fill"
    }
}



func getTextBy(status: Status) -> String {
    switch status {
    case .error:
        return localizedCXPatcherString(forKey: "PatchStatusError")
    case .unpatched:
        return localizedCXPatcherString(forKey: "PatchStatusReady")
    case .success:
        return localizedCXPatcherString(forKey: "PatchStatusSuccess")
    case .alreadyPatched:
        return localizedCXPatcherString(forKey: "PatchStatusAlreadyPatched")
    }
}

func getExternalPathFrom(url: URL) -> String {
    return url.path + SHARED_SUPPORT_PATH + EXTERNAL_FRAMEWORK_PATH
}

func hasExternal(url: URL) -> Bool{
    let path = getExternalPathFrom(url: url)
    return f.fileExists(atPath: path)
}

func patch(url: URL, externalUrl: URL? = nil) {
    let resources = externalUrl != nil ? getResourcesListFrom(url: url) : getResourcesListFrom(url: url).filter { elem in
        elem.0 != "crossover.inf"
    }
    if(externalUrl != nil) {
        print("copying externals...")
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
        patch(url: url)
        status = .success
    }
    return
}

func restoreApp(url: URL) -> Bool {
    if(!isAlreadyPatched(url: url) || !isCrossoverApp(url: url)) {
        if(!isAlreadyPatched(url: url)) {
            print("it's not patched")
        }
        if (!isCrossoverApp(url: url)){
            print("it isn't a crossover app")
        }
        
        return false
    }
    let filesToRestore = getResourcesListFrom(url: url)
    if(hasExternal(url: url)) {
        let externalFilesToRestore = getExternalResourcesList(fromUrl: url, toUrl: url)
        let externalPath = getExternalPathFrom(url: url)
        do {try f.removeItem(atPath: externalPath)
            print("deleting external")
        } catch {
            print("can't delete file external")
        }
        externalFilesToRestore.forEach { file in
            restoreFile(dest: file.1, ext: nil)
        }
    }
    filesToRestore.forEach { file in
        restoreFile(dest: file.1, ext: file.2)
    }
    return true
}

func restoreAndPatch(repatch: Bool, url: URL, status: inout Status, externalUrl: URL? = nil, skipVersionCheck: Bool?) {
    if repatch && restoreApp(url: url) {
        print("Restoring first...")
    }
    applyPatch(url: url, status: &status, externalUrl: externalUrl, skipVersionCheck: skipVersionCheck)
}

func localizedCXPatcherString(forKey key: String) -> String {
    var message = Bundle.main.localizedString(forKey: key, value: nil, table: "Localizable")
    if message == key {
        let enPath = Bundle.main.path(forResource: "en", ofType: "lproj")
        let enBundle = Bundle(path: enPath!)
        message = enBundle?.localizedString(forKey: key, value: nil, table: "Localizable") ?? key
    }
    return message
}

func validate(input: String) -> Bool {
    if(input == localizedCXPatcherString(forKey:"confirmationValue")) {
        return true
    }
    return false
}
