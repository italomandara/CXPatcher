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
    case fileExists
    case hasBackup
}

enum DeleteStatus {
    case failed
    case success
    case idle
    case progress
}

struct PathMap {
    var src: String
    var dst: String
}

struct Env {
    var key: String
    var value: String
}

struct GlobalEnvs {
    var fastMathDisabled = false
    var mtlHudEnabled = false
    var dxvkAsync = true
    var disableUE4Hack = false
    var advertiseAVX = false
    var preferredMaxFrameRate = 0.0
    var metalSpatialUpscaleFactor = 1.0
    var metalFXSpatial = false
    var disableMVKArgumentBuffers = true
}

enum PatchMVK {
    case legacyUE4
    case latestUE4
    case experimentalUE4
    case none
}

class Console {
    var logMessages: [String] = []
    
    func log(_ msg: String) {
        print(msg)
        logMessages.append(msg)
    }
    func saveLogs(to: URL) {
        if f.fileExists(atPath: to.path()) {
            do {
                try f.removeItem(at: to)
            } catch {
                print(error)
            }
        }
        let content = logMessages.joined(separator: "\n")
        print("Saving logs to \(to)")
        do {
            try content.write(to: to, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
    }
}

var console = Console()

func acceptAgreement(_ showDisclaimer: inout Bool) {
    showDisclaimer = false
    UserDefaults.standard.set(true, forKey: "I will not ask CodeWeavers for support or refund")
}

func describe(_ any: Any, indent: String = "") -> String {
    let mirror = Mirror(reflecting: any)
    
    // If it's a primitive or a type without children, just return it
    if mirror.children.isEmpty {
        return "\(any)"
    }
    
    var result = ""
    for (label, value) in mirror.children {
        guard let label = label else { continue }
        let valueMirror = Mirror(reflecting: value)
        
        if valueMirror.children.isEmpty {
            result += "\(indent)\(label): \(value)\n"
        } else {
            result += "\(indent)\(label):\n"
            result += describe(value, indent: indent + "  ")
        }
    }
    return result
}

struct Opts {
    var showDisclaimer: Bool = !UserDefaults.standard.bool(forKey: "I will not ask CodeWeavers for support or refund")
    var status: Status = .unpatched
    var skipVersionCheck: Bool = false
    var repatch: Bool = false
    var overrideBottlePath: Bool = true
    var copyGptk = false
    var progress: Float = 0.0
    var busy: Bool = false
    var cxbottlesPath = DEFAULT_CX_BOTTLES_PATH
    var patchMVK: PatchMVK = PatchMVK.legacyUE4
    var autoUpdateDisable = true
    var patchDXVK = false
    var patchGStreamer = true
    var globalEnvs = GlobalEnvs()
    var removeSignaure = true
    var xtLibsUrl: URL? = nil
    var copyXtLibs = false
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

var f = FileManager.default

private func getResourcesListFrom(url: URL) -> [(String, String)]{
    let list: [(String, String)]  = WINE_RESOURCES_PATHS.map { path in
        (
            WINE_RESOURCES_ROOT + path,
            url.path + SHARED_SUPPORT_PATH + path
        )
    }
    return list
}

private func getRemoveListFrom(url: URL) -> [String]{
    let list: [String]  = FILES_TO_REMOVE.map { path in
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
            console.log("\(res) copied")
        } catch {
            console.log(error.localizedDescription)
        }
    } else {
        console.log("\(res) not found")
    }
}

private func safeResCopy(res: String, dest: String) {
    //    console.log("moving \(dest + maybeExt(ext))")
    if(ENABLE_RESTORE != true){
        do {try f.removeItem(atPath: dest)
        } catch {
            console.log("\(dest) does not exist!")
        }
    } else if(f.fileExists(atPath: dest)) {
        do {try f.moveItem(atPath: dest, toPath: dest + "_orig")
        } catch {
            console.log("\(dest) does not exist!")
        }
    } else {
        console.log("unexpected error: \(dest) doesn't have an original copy will just copy then")
    }
    resCopy(res: res, dest: dest)
}

private func safeFileCopy(source: String, dest: String) {
//    console.log("moving \(dest + maybeExt(ext))")
    if(ENABLE_RESTORE != true){
        do {try f.removeItem(atPath: dest)
        } catch {
            console.log("\(dest) does not exist!")
        }
    } else if(f.fileExists(atPath: dest)) {
        do {try f.moveItem(atPath: dest, toPath: dest + "_orig")
        } catch {
            console.log("\(dest) does not exist!")
        }
    } else {
        console.log("file doesn't exist I'll just copy then")
    }

    do { try f.copyItem(at: URL(filePath: source), to: URL(filePath: dest))
        console.log("\(source) copied")
    } catch {
        console.log(error.localizedDescription)
    }

}

private func restoreFile(dest: String) {
    if(f.fileExists(atPath: dest)) {
        do {try f.removeItem(atPath: dest)
            console.log("deleting \(dest)")
        } catch {
            console.log("can't delete file \(dest)")
        }
    } else {
        console.log("file \(dest) doesn't exist... ignoring and deleting just _orig if found")
    }
    if(f.fileExists(atPath: dest + "_orig")) {
        do {try f.moveItem(atPath: dest + "_orig", toPath: dest)
            console.log("copying \(dest)")
        } catch {
            console.log("can't move file \(dest)")
        }
    } else {
        console.log("file \(dest) doesn't exist... ignoring")
    }
}

private func disable(dest: String) {
    do {try f.moveItem(atPath: dest, toPath: dest  + "_disabled")
        console.log("disabling \(dest)")
    } catch {
        console.log("can't move file \(dest)")
    }
}

private func remove(dest: String) {
    do {try f.removeItem(atPath: dest)
        console.log("removing \(dest)")
    } catch {
        console.log("can't remove file \(dest)")
    }
}

private func enable(dest: String) {
    do {try f.moveItem(atPath: dest + "_disabled", toPath: dest)
        console.log("disabling \(dest)")
    } catch {
        console.log("can't move file \(dest)")
    }
}

func isAlreadyPatched(url: URL) -> Bool {
    let plistPath = url.path + "/Contents/Info.plist"
    if (f.fileExists(atPath: plistPath)) {
        let plist = parseCXPlist(plistPath: plistPath)
        if (plist.CFBundleShortVersionString.hasSuffix("p")) {
            return true
        }
        return false
    }
    return true
}

func hasBackup(appRoot: URL) -> Bool {
    var backupUrl = appRoot
    let appName = appRoot.lastPathComponent.replacingOccurrences(of: ".app", with: "")
    backupUrl.deleteLastPathComponent()
    backupUrl.appendPathComponent(appName + "_original.app")
    return f.fileExists(atPath: backupUrl.path())
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
        if (plist.CFBundleIdentifier == "com.codeweavers.CrossOver" && plist.CFBundleShortVersionString.starts(with: SUPPORTED_CROSSOVER_VERSION) ) {
            console.log("app version is ok: \(plist.CFBundleShortVersionString)")
            return true
        }
    }
    console.log("file doesn't exist at \(plistPath)")
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
                    applyPatch(url: url, opts: &opts, onPatch: onPatch)
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
    case .alreadyPatched, .hasBackup:
        return .orange
    case .error, .fileExists:
        return .red
    }
}

func getIconBy(status: Status) -> String {
    switch status {
    case .unpatched:
        return "plus.app"
    case .success:
        return "checkmark.circle.fill"
    case .alreadyPatched, .hasBackup:
        return "hand.raised.app.fill"
    case .error, .fileExists:
        return "x.circle.fill"
    }
}

func getTextBy(status: Status) -> String {
    switch status {
    case .error:
        return localizedCXPatcherString(forKey: "PatchStatusError", value: SUPPORTED_CROSSOVER_VERSION)
    case .unpatched:
        return localizedCXPatcherString(forKey: "PatchStatusReady")
    case .success:
        return localizedCXPatcherString(forKey: "PatchStatusSuccess")
    case .alreadyPatched:
        return localizedCXPatcherString(forKey: "PatchStatusAlreadyPatched")
    case .hasBackup:
        return localizedCXPatcherString(forKey: "hasAlreadyBackup")
    case.fileExists:
        return localizedCXPatcherString(forKey: "PatchStatusFileExists")
    }
}

func getExternalPathFrom(url: URL) -> String {
    return url.path + SHARED_SUPPORT_PATH + EXTERNAL_RESOURCES_ROOT
}

func hasExternal(url: URL) -> Bool{
    let path = getExternalPathFrom(url: url)
    return f.fileExists(atPath: path)
}

func installDXMT (url: URL, opts: Opts) {
    if(opts.xtLibsUrl == nil) {
        console.log("Could not find dxmt source, skipping installation")
        return
    }
    
    let dxmtPath = opts.xtLibsUrl!.path + "/"
    
    let artifactTestPath = URL(fileURLWithPath: dxmtPath + DXMT_PATHS[0].src).path
    let releaseTestPath = URL(fileURLWithPath: dxmtPath + DXMT_PATHS_RELEASE[0].src).path
    
    if(f.fileExists(atPath: artifactTestPath)) {
        console.log("Artifact version detected, copying DXMT")
        DXMT_PATHS.forEach { path in
            let artifactPathSrc = URL(fileURLWithPath: dxmtPath + path.src).path
            let artifactPathDest = URL(fileURLWithPath: url.path + SHARED_SUPPORT_PATH + path.dst).path
            safeFileCopy(source: artifactPathSrc, dest: artifactPathDest)
        }
    } else if (f.fileExists(atPath: releaseTestPath)) {
        console.log("Release version detected, copying DXMT")
        let dxmt32Folder = url.appendingPathComponent(SHARED_SUPPORT_PATH).appendingPathComponent("lib/dxmt/i386-windows")
        
        if(f.fileExists(atPath: dxmt32Folder.path() ) == false){
            console.log("\(dxmt32Folder.path()) does not exist, creating")
            do {
                try f.createDirectory(at: dxmt32Folder, withIntermediateDirectories: true)
                console.log("\(dxmt32Folder.path()) created")
            } catch {
                console.log(error.localizedDescription)
            }
        }
        DXMT_PATHS_RELEASE.forEach { path in
            let releasePathSrc = URL(fileURLWithPath: dxmtPath + path.src).path
            let releasePathDest = URL(fileURLWithPath: url.path + SHARED_SUPPORT_PATH + path.dst).path
            safeFileCopy(source: releasePathSrc, dest: releasePathDest)
        }
    } else {
        console.log("Could not find dxmt source at '\(artifactTestPath)' nor '\(releaseTestPath)', skipping installation")
    }
}

func installWineMetalInAllBottles(opts: Opts) {
    do {
        let home: URL = f.homeDirectoryForCurrentUser
        let bottlesFolder: URL = opts.cxbottlesPath == DEFAULT_CX_BOTTLES_PATH ? home.appendingPathComponent(DEFAULT_CX_BOTTLES_FOLDER) : URL(fileURLWithPath: opts.cxbottlesPath, isDirectory: true)
        // list al bottles folders URLs
        let bottleFolders: [URL] = try f.contentsOfDirectory(at: bottlesFolder, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
        let bottleUrls: [URL] = bottleFolders
        console.log(bottleUrls.debugDescription)
        bottleUrls.forEach { bottleUrl in
            DXMT_EVERY_BOTTLE_SYS_PATHS.forEach { item in
                safeFileCopy(source: opts.xtLibsUrl!.path() + item.fullPath, dest: bottleUrl.appendingPathComponent("drive_c/windows/system32/", isDirectory: true).path() + item.fileName)
            }
        }
    } catch {
        console.log(error.localizedDescription)
    }
}

func patch(url: URL, opts: inout Opts) {
    if(ENABLE_BACKUP) {
        do
        {
            try backup(appRoot: url)
        }
        catch {
            console.log(error.localizedDescription)
            console.log("couldn't create the backup")
            return
        }
    }
    let resources = getResourcesListFrom(url: url).filter { elem in
        opts.copyGptk && !opts.copyXtLibs ? true : !elem.0.contains("crossover.inf")
    }.filter { elem in
        opts.patchMVK == PatchMVK.legacyUE4 ? true : !elem.0.contains("libMoltenVK.dylib")
    }.filter { elem in
        opts.patchDXVK ? true : (!elem.0.contains("dxvk") && !elem.0.contains("dxvk"))
    }
    if(opts.copyXtLibs) {
        installDXMT(url: url, opts: opts)
//        installWineMetalInAllBottles(opts: opts) not needed at the moment, just create a new bottle
    }
    opts.progress += 1
    let filesToRemove = getRemoveListFrom(url: url).filter { elem in
        opts.removeSignaure ? true : (!elem.contains("CodeResources") && !elem.contains("_CodeSignature"))
    }
    opts.progress += 1
    if(opts.copyGptk == true) {
        console.log("copying externals...")
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
    if(opts.patchMVK == PatchMVK.latestUE4) {
        let latestMVKResource = (
            WINE_RESOURCES_ROOT + MOLTENVK_LATEST,
            url.path + SHARED_SUPPORT_PATH + MOLTENVK_BASELINE
        )
        safeResCopy(res: latestMVKResource.0, dest: latestMVKResource.1)
    }
    if(opts.patchMVK == PatchMVK.experimentalUE4) {
        let latestMVKResource = (
            WINE_RESOURCES_ROOT + MOLTENVK_EXPERIMENTAL,
            url.path + SHARED_SUPPORT_PATH + MOLTENVK_BASELINE
        )
        safeResCopy(res: latestMVKResource.0, dest: latestMVKResource.1)
    }
//    filesToDisable.forEach { file in
//        disable(dest: file)
//        opts.progress += 1
//    }
    filesToRemove.forEach { file in
        remove(dest: file)
        opts.progress += 1
    }
    if(opts.overrideBottlePath == true) {
        addGlobals(url: url, opts: opts)
    }
    opts.progress += 1
    if(opts.autoUpdateDisable) {
        disableAutoUpdate(url: url)
    }
    opts.progress += 1
    markAsPatched(url: url)
}

func renameApp (url: URL) throws -> URL {
    let appName = url.lastPathComponent.split(separator: ".").first ?? ""
    let patchedName = url.deletingLastPathComponent().appendingPathComponent(appName + "_patched.app")
    let originalName = url.deletingLastPathComponent().appendingPathComponent(appName + "_original.app")
    if f.fileExists(atPath: patchedName.path) {
        try f.removeItem(at: patchedName)
    }
    do {
        try f.moveItem(at: url, to: patchedName)
        console.log("renaming the app at \(url.path) to \(patchedName.path)")
    }
    do {
        try f.moveItem(at: originalName, to: URL(fileURLWithPath: url.path))
        console.log("renaming the app at \(originalName.path) to \(url.path)")
    }
    console.log("renaming successful")
    return patchedName
}

func validateAndPatch(url: URL, opts: inout Opts, onPatch: () -> Void = {}) {
    if (isAlreadyPatched(url: url)) {
        console.log("App is already patched")
        opts.status = .alreadyPatched
        return
    }
    if(!isCrossoverApp(url: url, skipVersionCheck: opts.skipVersionCheck)) {
        console.log("it' s not crossover.app")
        opts.status = .error
        return
    }
    if(hasBackup(appRoot: url)) {
        console.log("Can't patch the app if the backup is already there at \(url.path())")
        opts.status = .hasBackup
    }
    console.log("it's a crossover app")
    onPatch()
    patch(url: url, opts: &opts)
    return
}

func restoreApp(url: URL, opts: inout Opts, onRestore: () -> Void = {}) -> Bool {
    if(!isAlreadyPatched(url: url) || !isCrossoverApp(url: url)) {
        if(!isAlreadyPatched(url: url)) {
            console.log("it's not patched")
        }
        if (!isCrossoverApp(url: url)){
            console.log("it isn't a crossover app")
        }
        
        return false
    }
    onRestore()
    let filesToRestore = getResourcesListFrom(url: url)
//    let filesToEnable = getDisableListFrom(url: url)
    if(hasExternal(url: url)) {
        let externalFilesToRestore = getExternalResourcesList(url: url)
        externalFilesToRestore.forEach { file in
            restoreFile(dest: file.1)
        }
    }
    filesToRestore.forEach { file in
        restoreFile(dest: file.1)
        opts.progress += 1
    }
//    filesToEnable.forEach { file in
//        enable(dest: file)
//        opts.progress += 1
//    }
    restoreAutoUpdate(url: url)
    opts.progress += 1
    removeGlobals(url: url)
    opts.progress += 1
    return true
}

func localizedCXPatcherString(forKey key: String, value: String? = nil) -> String {
    var message = Bundle.main.localizedString(forKey: key, value: nil, table: "Localizable")
    if message == key {
        let enPath = Bundle.main.path(forResource: "en", ofType: "lproj")
        let enBundle = Bundle(path: enPath!)
        message = enBundle?.localizedString(forKey: key, value: nil, table: "Localizable") ?? key
    }
    return value == nil  ? message : String(format: message , value!)
}

func validate(input: String) -> Bool {
    if(input.lowercased() == localizedCXPatcherString(forKey:"confirmationValue").lowercased()) {
        return true
    }
    return false
}

private func editInfoPlist(at: URL, key: String, value: String) {
    let url = at.appendingPathComponent(PLIST_PATH)
    var plist: [String:Any] = [:]
    if let data = f.contents(atPath: url.path) {
        do {
            plist = try PropertyListSerialization.propertyList(from: data, options:PropertyListSerialization.ReadOptions(), format:nil) as! [String:Any]
            plist[key] = value
            console.log("set info property list \(key) = \(value)")
        } catch {
            console.log("\(error) - there was a problem parsing the xml")
        }
    }
    do {try f.moveItem(atPath: url.path, toPath: url.path + "_orig")
    } catch {
        console.log("\(url.path) does not exist!")
    }
    NSDictionary(dictionary: plist).write(to: url, atomically: true)
}

func disableAutoUpdate(url: URL) {
    editInfoPlist(at: url, key: "SUFeedURL", value: "")
}

func markAsPatched(url: URL) {
    let plist = parseCXPlist(plistPath: url.path + "/Contents/Info.plist")
    editInfoPlist(at: url, key: "CFBundleShortVersionString", value: plist.CFBundleShortVersionString + "p")
}

func restoreAutoUpdate(url: URL) {
    let plistURL = url.appendingPathComponent(PLIST_PATH)
    restoreFile(dest: plistURL.path)
    console.log("restored original Info.plist")
}

func backup(appRoot: URL) throws {
    //    let downloadsDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
    //    var backupUrl = downloadsDirectory
    var backupUrl = appRoot
    let appName = appRoot.lastPathComponent.replacingOccurrences(of: ".app", with: "")
    backupUrl.deleteLastPathComponent()
    backupUrl.appendPathComponent(appName + "_original.app")
    console.log(backupUrl.debugDescription)
    try f.copyItem(at: appRoot, to: backupUrl)
}

private func appendLinesToFile(filePath: String, additionalLines: [String]) -> String {
    console.log("tryng to read \(filePath)")
    if let sourceUrl = Bundle.main.url(forResource:  filePath, withExtension: nil) {
        console.log(sourceUrl.debugDescription)
        do { let text = try String(contentsOf: sourceUrl, encoding: .utf8)
            var finalLines: String = ""
            console.log("total envs: \(additionalLines.count)")
            for additionalLine in additionalLines {
                finalLines += additionalLine + "\n"
                console.log(additionalLine)
            }
            console.log(finalLines)
            return text + finalLines
        } catch {
            console.log("failed opening config file")
        }
    } else {
        console.log("\(filePath) not found")
    }
    return ""
}

private func toCrossoverENVString(_ key: String, _ value: String) -> String {
    return "\"\(key)\"=\"\(value)\""
}

private func getENVOverrideConfigfile(envs: [Env]) -> String {
    let filePath = WINE_RESOURCES_ROOT + BOTTLE_PATH_OVERRIDE
    let additionallines: [String] = envs.map { env in
        toCrossoverENVString(env.key, env.value)
    }
    return appendLinesToFile(filePath: filePath, additionalLines: additionallines)
}

func addGlobals(url: URL, opts: Opts) {
    disable(dest: url.path + SHARED_SUPPORT_PATH + BOTTLE_PATH_OVERRIDE)
    var envs: [Env] = [Env(key: "CX_BOTTLE_PATH", value: opts.cxbottlesPath)]
    var DXMTConfigvalues = ""
    if(opts.patchMVK == .legacyUE4) {
        console.log("add enable UE4 Hack env")
        envs += [Env(key: "MVK_CONFIG_UE4_HACK_ENABLED", value: "1")]
    }
    if(opts.globalEnvs.metalFXSpatial == true) {
        console.log("add metalFXSpatial env")
        envs += [Env(key: "DXMT_METALFX_SPATIAL_SWAPCHAIN", value: "1")]
    }
    if(opts.globalEnvs.metalFXSpatial == true && opts.globalEnvs.metalSpatialUpscaleFactor > 0) {
        console.log("add metalSpatialUpscaleFactor env")
        DXMTConfigvalues += "d3d11.metalSpatialUpscaleFactor=\(String(opts.globalEnvs.metalSpatialUpscaleFactor));"
    }
    if(opts.globalEnvs.preferredMaxFrameRate > 29.0) {
        console.log("add preferredMaxFrameRate env")
        DXMTConfigvalues += "d3d11.preferredMaxFrameRate=\(String(Int(opts.globalEnvs.preferredMaxFrameRate)));"
    }
    if(opts.globalEnvs.metalSpatialUpscaleFactor > 0 || opts.globalEnvs.preferredMaxFrameRate > 29.0) {
        envs += [Env(key: "DXMT_CONFIG", value: DXMTConfigvalues)]
    }
    if(opts.globalEnvs.mtlHudEnabled == true) {
        console.log("add mtlHudEnabled env")
        envs += [Env(key: "MTL_HUD_ENABLED", value: "1")]
    }
    if(opts.globalEnvs.advertiseAVX == true) {
        console.log("add advertiseAVX env")
        envs += [Env(key: "ROSETTA_ADVERTISE_AVX", value: "1")]
    }
    if(opts.globalEnvs.fastMathDisabled == true) {
        console.log("add fastMathDisabled env")
        envs += [Env(key: "MVK_CONFIG_FAST_MATH_ENABLED", value: "0")]
    }
    if(opts.globalEnvs.dxvkAsync == true) {
        console.log("add DXVK async env")
        envs += [Env(key: "DXVK_ASYNC", value: "1")]
    }
    if(opts.globalEnvs.disableUE4Hack == true) {
        console.log("add UE4 disable env")
        envs += [Env(key: "NAS_DISABLE_UE4_HACK", value: "1")]
    }
    
    if(opts.globalEnvs.disableMVKArgumentBuffers == true) { // to add the option later
        console.log("disable MoltenVK Argument Buffers")
        envs += [Env(key: "MVK_CONFIG_USE_METAL_ARGUMENT_BUFFERS", value: "0")]
    }
    
    console.log("enable MoltenVK UE4 HAck")
    envs += [Env(key: "MVK_CONFIG_UE4_HACK_ENABLED", value: "1")]

    let file = getENVOverrideConfigfile(envs: envs)
    do {
        try file.write(to: url.appendingPathComponent(SHARED_SUPPORT_PATH + BOTTLE_PATH_OVERRIDE), atomically: false, encoding: .utf8)
    } catch {
        console.log(error.localizedDescription)
    }
}

func removeGlobals(url: URL) {
    do {
        try f.removeItem(atPath: url.path + SHARED_SUPPORT_PATH + BOTTLE_PATH_OVERRIDE)
    } catch {
        console.log(error.localizedDescription)
    }
    enable(dest: url.path + SHARED_SUPPORT_PATH + BOTTLE_PATH_OVERRIDE)
}

@discardableResult
func safeShell(_ command: String) throws -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated
    task.standardInput = nil

    try task.run() //<--updated
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return output
}

func darwinUserCacheDir() -> URL? {
    var buf = [CChar](repeating: 0, count: 1024)
    let success = confstr(_CS_DARWIN_USER_CACHE_DIR, &buf, buf.count) >= 0
    guard success else { return nil }
    return URL(fileURLWithFileSystemRepresentation: &buf, isDirectory: true, relativeTo: nil)
}

func removeD3DMetalCaches() -> DeleteStatus {
    do {
        let d3dmPath = darwinUserCacheDir()!.appendingPathComponent(D3DM_CACHE_FOLDER, isDirectory: true).path

        let _items = try f.contentsOfDirectory(atPath: d3dmPath)
        let items = try _items.filter { d3dmPath in
                let pattern = try Regex(#"^.*\.exe$"#)
                return d3dmPath.contains(pattern)
        }
        for itemPath in items {
            console.log("Deleting \(itemPath)")
            try f.removeItem(atPath: d3dmPath + "/"  + itemPath)
        }
    } catch {
        console.log(error.localizedDescription)
        return DeleteStatus.failed
    }

    return DeleteStatus.success
}

func getAllSteamShaderCacheDirectories() -> [URL] {
    var shaderCacheDirectories = [URL]()
    
    // Get all mounted volumes
    if let volumes = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: nil, options: .skipHiddenVolumes) {
        for volumeURL in volumes {
            // Enumerate contents of each volume
            if let enumerator = FileManager.default.enumerator(at: volumeURL, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
                for case let fileURL as URL in enumerator {
                    // Check if the file URL is a directory
                    if let resourceValues = try? fileURL.resourceValues(forKeys: [.isDirectoryKey]),
                       resourceValues.isDirectory == true {
                        // Directly match the "steamapps/shadercache" path
                        let path = fileURL.path
                        if path.hasSuffix("/steamapps/shadercache") {
                            shaderCacheDirectories.append(fileURL)
                            // Skip the contents of this directory
                            enumerator.skipDescendants()
                        }
                    }
                }
            }
        }
    }
    
    return shaderCacheDirectories
}

func shortenSteamCachePath(_ path: String) -> String {
    return path.replacingOccurrences(of:"file://", with: "")
        .replacingOccurrences(of: "/Users/(.*?)/", with: "~/", options: .regularExpression)
        .replacingOccurrences(of: "/Volumes/(.*?)/", with: "$1/", options: .regularExpression)
        .replacingOccurrences(of: ".*/CXPBottles/(.*?)/.*", with: "$1:", options: .regularExpression)
        .replacingOccurrences(of: "steamapps/shadercache/", with: "")
}

func removeAllSteamCachesFrom(path: String) -> DeleteStatus {
    do {
        let items = try f.contentsOfDirectory(atPath: path)
        for item in items {
            console.log("deleting \(path + "/" + item)")
            try f.removeItem(atPath: path + "/" + item)
        }
    } catch {
        console.log(error.localizedDescription)
        return DeleteStatus.failed
    }
    return DeleteStatus.success
}
