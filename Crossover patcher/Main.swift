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
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        console.log("CXPatcher Version: \(version)")
    }
    console.log("Patched on \(Date().ISO8601Format())")
    console.log("--- BEGIN OPTIONS ---\n \(describe(opts)) \n --- END OPTIONS ---")
    opts.progress = 0.0
    opts.busy = true
    if opts.repatch && restoreApp(url: url, opts: &opts) {
        console.log("Restoring first...")
    }
    var logFile: URL
    do {
        if let patchedUrl = try validateAndPatch(url: url, opts: &opts, onPatch: onPatch) {
            opts.status = .success
            logFile = patchedUrl.appendingPathComponent("Contents").appendingPathComponent("cxplog.txt")
        } else {
            opts.status = .error
            logFile = url.deletingLastPathComponent().appendingPathComponent("cxplog.txt")
        }
    } catch {
        console.log(error.localizedDescription)
        opts.status = .error
        logFile = url.deletingLastPathComponent().appendingPathComponent("cxplog.txt")
    }
    console.saveLogs(to: logFile)
    opts.busy = false
}
