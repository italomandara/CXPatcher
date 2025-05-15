//
//  Main.swift
//  CXPatcher
//
//  Created by Italo Mandara on 02/05/2025.
//

import Foundation

func applyPatch(url: URL, opts: inout Opts, onPatch: () -> Void = {}) {
    if (opts.busy) {
        return
    }
    console.log("--- BEGIN OPTIONS ---\n \(describe(opts)) \n --- END OPTIONS ---")
    opts.progress = 0.0
    opts.busy = true
    if opts.repatch && restoreApp(url: url, opts: &opts) {
        console.log("Restoring first...")
    }
    validateAndPatch(url: url, opts: &opts, onPatch: onPatch)
    if(ENABLE_FIX_CX_CODESIGN) {
        do {
            console.log("patching \(url.path)")
            let p = try safeShell("/usr/bin/xattr -cr \(url.path) && /usr/bin/codesign --force --deep --sign - \(url.path)")
            console.log(p)
        } catch {
            console.log("xattr or codesign failed")
            console.log(error.localizedDescription)
        }
    }
    do {
        let patchedUrl = try renameApp(url: url)
        opts.status = .success
        let logFile = patchedUrl.appendingPathComponent("Contents").appendingPathComponent("cxplog.txt")
        console.saveLogs(to: logFile)
    } catch {
        console.log(error.localizedDescription)
        opts.status = .fileExists
        let logFile = url.deletingLastPathComponent().appendingPathComponent("cxplog.txt")
        console.saveLogs(to: logFile)
    }
    opts.busy = false
}
