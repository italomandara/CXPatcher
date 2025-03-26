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
}

enum PatchMVK {
    case legacyUE4
    case latestUE4
    case experimentalUE4
    case none
}

func acceptAgreement(_ showDisclaimer: inout Bool) {
    showDisclaimer = false
    UserDefaults.standard.set(true, forKey: "I will not ask CodeWeavers for support or refund")
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
    var patchDXVK = true
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
    if(ENABLE_RESTORE != true){
        do {try f.removeItem(atPath: dest)
        } catch {
            print("\(dest) does not exist!")
        }
    } else if(f.fileExists(atPath: dest)) {
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
    if(ENABLE_RESTORE != true){
        do {try f.removeItem(atPath: dest)
        } catch {
            print("\(dest) does not exist!")
        }
    } else if(f.fileExists(atPath: dest)) {
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

private func remove(dest: String) {
    do {try f.removeItem(atPath: dest)
        print("removing \(dest)")
    } catch {
        print("can't remove file \(dest)")
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
        if (plist.CFBundleIdentifier == "com.codeweavers.CrossOver" && plist.CFBundleShortVersionString.starts(with: SUPPORTED_CROSSOVER_VERSION) ) {
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
        return localizedCXPatcherString(forKey: "PatchStatusError", value: SUPPORTED_CROSSOVER_VERSION)
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

func installDXMT (url: URL, opts: Opts) {
    if(opts.xtLibsUrl == nil) {
        print("Could not find dxmt source, skipping installation")
        return
    }
    if(f.fileExists(atPath: opts.xtLibsUrl!.path() + DXMT_PATHS[0].src)) {
        print("Artifact version detected, copying DXMT")
        DXMT_PATHS.forEach { path in
            safeFileCopy(source: opts.xtLibsUrl!.path() + path.src, dest: url.path + SHARED_SUPPORT_PATH + path.dst)
        }
    } else if (f.fileExists(atPath: opts.xtLibsUrl!.path() + DXMT_PATHS_RELEASE[0].src)) {
        print("Release version detected, copying DXMT")
        DXMT_PATHS_RELEASE.forEach { path in
            safeFileCopy(source: opts.xtLibsUrl!.path() + path.src, dest: url.path + SHARED_SUPPORT_PATH + path.dst)
        }
    }
}

func installWineMetalInAllBottles(opts: Opts) {
    do {
        let home: URL = f.homeDirectoryForCurrentUser
        let bottlesFolder: URL = opts.cxbottlesPath == DEFAULT_CX_BOTTLES_PATH ? home.appendingPathComponent(DEFAULT_CX_BOTTLES_FOLDER) : URL(fileURLWithPath: opts.cxbottlesPath, isDirectory: true)
        // list al bottles folders URLs
        let bottleFolders: [URL] = try f.contentsOfDirectory(at: bottlesFolder, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
        let bottleUrls: [URL] = bottleFolders
        print(bottleUrls)
        bottleUrls.forEach { bottleUrl in
            DXMT_EVERY_BOTTLE_SYS_PATHS.forEach { item in
                safeFileCopy(source: opts.xtLibsUrl!.path() + item.fullPath, dest: bottleUrl.appendingPathComponent("drive_c/windows/system32/", isDirectory: true).path() + item.fileName)
            }
        }
    } catch {
        print(error)
    }
}

func patch(url: URL, opts: inout Opts) {
    if(ENABLE_BACKUP) {
        do
        {
            try backup(appRoot: url)
        }
        catch {
            print(error)
            print("couldn't create the backup")
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
    if(ENABLE_FIX_CX_CODESIGN) {
        do {
            print("patching \(url.path)")
            let p = try safeShell("/usr/bin/xattr -cr \(url.path) && /usr/bin/codesign --force --deep --sign - \(url.path)")
            print(p)
        } catch {
            print("xattr or codesign failed")
            print(error)
        }
    }
    opts.busy = false
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

func backup(appRoot: URL) throws {
    //    let downloadsDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
    //    var backupUrl = downloadsDirectory
    var backupUrl = appRoot
    let appName = appRoot.lastPathComponent.replacingOccurrences(of: ".app", with: "")
    backupUrl.deleteLastPathComponent()
    backupUrl.appendPathComponent(appName + "_original.app")
    print(backupUrl)
    try f.copyItem(at: appRoot, to: backupUrl)
}

private func appendLinesToFile(filePath: String, additionalLines: [String]) -> String {
    print("tryng to read \(filePath)")
    if let sourceUrl = Bundle.main.url(forResource:  filePath, withExtension: nil) {
        print(sourceUrl)
        do { let text = try String(contentsOf: sourceUrl, encoding: .utf8)
            var finalLines: String = ""
            print("total envs: \(additionalLines.count)")
            for additionalLine in additionalLines {
                finalLines += additionalLine + "\n"
                print(additionalLine)
            }
            print(finalLines)
            return text + finalLines
        } catch {
            print("failed opening config file")
        }
    } else {
        print("\(filePath) not found")
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
        print("add enable UE4 Hack env")
        envs += [Env(key: "MVK_CONFIG_UE4_HACK_ENABLED", value: "1")]
    }
    if(opts.globalEnvs.metalFXSpatial == true) {
        print("add metalFXSpatial env")
        envs += [Env(key: "DXMT_METALFX_SPATIAL_SWAPCHAIN", value: "1")]
    }
    if(opts.globalEnvs.metalFXSpatial == true && opts.globalEnvs.metalSpatialUpscaleFactor > 0) {
        print("add metalSpatialUpscaleFactor env")
        DXMTConfigvalues += "d3d11.metalSpatialUpscaleFactor=\(String(opts.globalEnvs.metalSpatialUpscaleFactor));"
    }
    if(opts.globalEnvs.preferredMaxFrameRate > 29.0) {
        print("add preferredMaxFrameRate env")
        DXMTConfigvalues += "d3d11.preferredMaxFrameRate=\(String(Int(opts.globalEnvs.preferredMaxFrameRate)));"
    }
    if(opts.globalEnvs.metalSpatialUpscaleFactor > 0 || opts.globalEnvs.preferredMaxFrameRate > 29.0) {
        envs += [Env(key: "DXMT_CONFIG", value: DXMTConfigvalues)]
    }
    if(opts.globalEnvs.mtlHudEnabled == true) {
        print("add mtlHudEnabled env")
        envs += [Env(key: "MTL_HUD_ENABLED", value: "1")]
    }
    if(opts.globalEnvs.advertiseAVX == true) {
        print("add advertiseAVX env")
        envs += [Env(key: "ROSETTA_ADVERTISE_AVX", value: "1")]
    }
    if(opts.globalEnvs.fastMathDisabled == true) {
        print("add fastMathDisabled env")
        envs += [Env(key: "MVK_CONFIG_FAST_MATH_ENABLED", value: "0")]
    }
    if(opts.globalEnvs.dxvkAsync == true) {
        print("add DXVK async env")
        envs += [Env(key: "DXVK_ASYNC", value: "1")]
    }
    if(opts.globalEnvs.disableUE4Hack == true) {
        print("add UE4 disable env")
        envs += [Env(key: "NAS_DISABLE_UE4_HACK", value: "1")]
    }

    let file = getENVOverrideConfigfile(envs: envs)
    do {
        try file.write(to: url.appendingPathComponent(SHARED_SUPPORT_PATH + BOTTLE_PATH_OVERRIDE), atomically: false, encoding: .utf8)
    } catch {
        print(error)
    }
}

func removeGlobals(url: URL) {
    do {
        try f.removeItem(atPath: url.path + SHARED_SUPPORT_PATH + BOTTLE_PATH_OVERRIDE)
    } catch {
        print(error)
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
            print("Deleting \(itemPath)")
            try f.removeItem(atPath: d3dmPath + "/"  + itemPath)
        }
    } catch {
        print(error)
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
            print("deleting \(path + "/" + item)")
            try f.removeItem(atPath: path + "/" + item)
        }
    } catch {
        print(error)
        return DeleteStatus.failed
    }
    return DeleteStatus.success
}
