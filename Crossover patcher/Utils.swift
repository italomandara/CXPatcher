//
//  Utils.swift
//  Crossover patcher
//
//  Created by Italo Mandara on 03/04/2023.
//

import Foundation
import SwiftUI

var isVentura: Bool {
    SKIP_VENTURA_CHECK ? false : ProcessInfo().operatingSystemVersion.majorVersion < 14
}

enum Status {
    case alreadyPatched
    case success
    case unpatched
    case error
}

struct Opts {
    var showDisclaimer: Bool = true
    var status: Status = .unpatched
    var skipVersionCheck: Bool = false
    var repatch: Bool = false
    var overrideBottlePath: Bool = true
    var copyGptk = true
    var progress: Float = 0.0
    var busy: Bool = false
    var cxbottlesPath = BOTTLE_PATH_OVERRIDE
    func getTotalProgress() -> Int32 {
        if(self.copyGptk && self.repatch) {
            return 136
        }
        if(self.copyGptk) {
            return 75
        }
        if(self.repatch) {
            return 124
        }
        return 63
    }
}

var f = FileManager()

private func getResourcesListFrom(url: URL) -> [(String, String)]{
    let list: [(String, String)]  = WINE_RESOURCES_PATHS.map { path in
        (
            WINE_RESOURCES_ROOT + path,
            url.path + SHARED_SUPPORT_PATH + path
        )
    }
    return list
}

private func getDisableListFrom(url: URL) -> [String]{
    let list: [String]  = FILES_TO_DISABLE.map { path in
        url.path + path
    }
    return list
}

private func getExternalResourcesList(url: URL) -> [(String, String)]{
    return EXTERNAL_WINE_PATHS.map { path in
        (
            "Crossover" + EXTERNAL_RESOURCES_ROOT + path,
            url.path + SHARED_SUPPORT_PATH + EXTERNAL_RESOURCES_ROOT + path
        )
    }
}

private func  getBackupListFrom(url: URL) -> [String] {
    let internalRes = getResourcesListFrom(url: url).map { (_, path) in
        path + "_orig"
    }
    return internalRes
}

private func  getExternalBackupListFrom(url: URL) -> [String] {
    let externalRes = EXTERNAL_WINE_PATHS.map { path in
        url.path + SHARED_SUPPORT_PATH + path + "_orig"
    }
    return externalRes
}

private func resCopy(res: String, dest: String) {
    if let sourceUrl = Bundle.main.url(forResource: res, withExtension: nil) {
        do { try f.copyItem(at: sourceUrl, to: URL(filePath: dest))
            print("\(res) copied")
        } catch {
            print(error)
        }
    } else {
        print("\(res) not found")
    }
}

private func safeResCopy(res: String, dest: String) {
//    print("moving \(dest + maybeExt(ext))")
    if(f.fileExists(atPath: dest)) {
        do {try f.moveItem(atPath: dest, toPath: dest + "_orig")
        } catch {
            print("\(dest) does not exist!")
        }
    } else {
        print("unexpected error: \(dest) doesn't have an original copy will just copy then")
    }
    resCopy(res: res, dest: dest)
}

private func safeFileCopy(source: String, dest: String) {
//    print("moving \(dest + maybeExt(ext))")
    if(f.fileExists(atPath: dest)) {
        do {try f.moveItem(atPath: dest, toPath: dest + "_orig")
        } catch {
            print("\(dest) does not exist!")
        }
    } else {
        print("file doesn't exist I'll just copy then")
    }

    do { try f.copyItem(at: URL(filePath: source), to: URL(filePath: dest))
        print("\(source) copied")
    } catch {
        print(error)
    }

}

private func restoreFile(dest: String) {
    if(f.fileExists(atPath: dest)) {
        do {try f.removeItem(atPath: dest)
            print("deleting \(dest)")
        } catch {
            print("can't delete file \(dest)")
        }
    } else {
        print("file \(dest) doesn't exist... ignoring and deleting just _orig if found")
    }
    if(f.fileExists(atPath: dest + "_orig")) {
        do {try f.moveItem(atPath: dest + "_orig", toPath: dest)
            print("copying \(dest)")
        } catch {
            print("can't move file \(dest)")
        }
    } else {
        print("file \(dest) doesn't exist... ignoring")
    }
}

private func disable(dest: String) {
    do {try f.moveItem(atPath: dest, toPath: dest  + "_disabled")
        print("disabling \(dest)")
    } catch {
        print("can't move file \(dest)")
    }
}

private func enable(dest: String) {
    do {try f.moveItem(atPath: dest + "_disabled", toPath: dest)
        print("disabling \(dest)")
    } catch {
        print("can't move file \(dest)")
    }
}

func isAlreadyPatched(url: URL) -> Bool {
    let filesToCheck = getBackupListFrom(url: url)
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
    let plistPath = url.path + "/Contents/Info.plist"
    if (f.fileExists(atPath: plistPath)) {
        let plist = parseCXPlist(plistPath: plistPath)
        if (plist.CFBundleIdentifier == "com.codeweavers.CrossOver" && skipVersionCheck == true) {
            return true
        }
        if (plist.CFBundleIdentifier == "com.codeweavers.CrossOver" && plist.CFBundleShortVersionString.starts(with: String(SUPPORTED_CROSSOVER_VERSION)) ) {
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
    @Binding var opts: Opts
    public var onPatch: () -> Void = {}
    func performDrop(info: DropInfo) -> Bool {
        if let item = info.itemProviders(for: [.fileURL]).first {
            let _ = item.loadObject(ofClass: URL.self) { object, error in
                if let url = object {
                    restoreAndPatch(url: url, opts: &opts, onPatch: onPatch)
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
    return url.path + SHARED_SUPPORT_PATH + EXTERNAL_RESOURCES_ROOT
}

func hasExternal(url: URL) -> Bool{
    let path = getExternalPathFrom(url: url)
    return f.fileExists(atPath: path)
}

func patch(url: URL, opts: inout Opts) {
    let resources = opts.copyGptk != false ? getResourcesListFrom(url: url) : getResourcesListFrom(url: url).filter { elem in
        elem.0 != "crossover.inf"
    }
    opts.progress += 1
    let filesToDisable = getDisableListFrom(url: url)
    opts.progress += 1
    if(opts.copyGptk == true) {
        print("copying externals...")
        let externalResources = getExternalResourcesList(url: url)
        externalResources.forEach { resource in
            safeResCopy(res: resource.0, dest: resource.1)
            opts.progress += 1
        }
    }
    resources.forEach { resource in
        safeResCopy(res: resource.0, dest: resource.1)
        opts.progress += 1
    }
    filesToDisable.forEach { file in
        disable(dest: file)
        opts.progress += 1
    }
    if(opts.overrideBottlePath == true) {
        overrideBottlePath(url: url, path: opts.cxbottlesPath)
    }
    opts.progress += 1
    disableAutoUpdate(url: url)
    opts.progress += 1
    opts.status = .success
}

func validateAndPatch(url: URL, opts: inout Opts, onPatch: () -> Void = {}) {
    if (isAlreadyPatched(url: url)) {
        print("App is already patched")
        opts.status = .alreadyPatched
        return
    }
    if(!isCrossoverApp(url: url, skipVersionCheck: opts.skipVersionCheck)) {
        print("it' s not crossover.app")
        opts.status = .error
        return
    }
    print("it's a crossover app")
    onPatch()
    patch(url: url, opts: &opts)
    return
}

func restoreApp(url: URL, opts: inout Opts, onRestore: () -> Void = {}) -> Bool {
    if(!isAlreadyPatched(url: url) || !isCrossoverApp(url: url)) {
        if(!isAlreadyPatched(url: url)) {
            print("it's not patched")
        }
        if (!isCrossoverApp(url: url)){
            print("it isn't a crossover app")
        }
        
        return false
    }
    onRestore()
    let filesToRestore = getResourcesListFrom(url: url)
    let filesToEnable = getDisableListFrom(url: url)
    if(hasExternal(url: url)) {
        let externalFilesToRestore = getExternalResourcesList(url: url)
        let externalPath = getExternalPathFrom(url: url)
        do {try f.removeItem(atPath: externalPath)
            print("deleting external")
        } catch {
            print("can't delete file external")
        }
        externalFilesToRestore.forEach { file in
            restoreFile(dest: file.1)
        }
    }
    filesToRestore.forEach { file in
        restoreFile(dest: file.1)
        opts.progress += 1
    }
    filesToEnable.forEach { file in
        enable(dest: file)
        opts.progress += 1
    }
    restoreAutoUpdate(url: url)
    opts.progress += 1
    removeOverrideBottlePath(url: url)
    opts.progress += 1
    return true
}

func restoreAndPatch(url: URL, opts: inout Opts, onPatch: () -> Void = {}) {
    if (opts.busy) {
        return
    }
    opts.progress = 0.0
    opts.busy = true
    if opts.repatch && restoreApp(url: url, opts: &opts) {
        print("Restoring first...")
    }
    validateAndPatch(url: url, opts: &opts, onPatch: onPatch)
    opts.busy = false
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
    if(input.lowercased() == localizedCXPatcherString(forKey:"confirmationValue").lowercased()) {
        return true
    }
    return false
}

func editInfoPlist(at: URL, key: String, value: String) {
    let url = at.appendingPathComponent(PLIST_PATH)
    var plist: [String:Any] = [:]
    if let data = f.contents(atPath: url.path) {
        do {
            plist = try PropertyListSerialization.propertyList(from: data, options:PropertyListSerialization.ReadOptions(), format:nil) as! [String:Any]
            plist[key] = value
            print("set info property list \(key) = \(value)")
        } catch {
            print("\(error) - there was a problem parsing the xml")
        }
    }
    do {try f.moveItem(atPath: url.path, toPath: url.path + "_orig")
    } catch {
        print("\(url.path) does not exist!")
    }
    NSDictionary(dictionary: plist).write(to: url, atomically: true)
}

func disableAutoUpdate(url: URL) {
    editInfoPlist(at: url, key: "SUFeedURL", value: "")
}

func restoreAutoUpdate(url: URL) {
    let plistURL = url.appendingPathComponent(PLIST_PATH)
    restoreFile(dest: plistURL.path)
    print("restored original Info.plist")
}

func overrideBottlePath(url: URL, path: String) {
    safeResCopy(res: WINE_RESOURCES_ROOT + path, dest: url.path + SHARED_SUPPORT_PATH + BOTTLE_PATH_OVERRIDE)
}

func removeOverrideBottlePath(url: URL) {
    restoreFile(dest: url.path + SHARED_SUPPORT_PATH + BOTTLE_PATH_OVERRIDE)
}
