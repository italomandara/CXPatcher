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
