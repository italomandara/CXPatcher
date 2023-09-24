//
//  Config.swift
//  Crossover patcher
//
//  Created by Italo Mandara on 24/06/2023.
//

import Foundation

let SKIP_VENTURA_CHECK = false
let SKIP_DISCLAIMER_CHECK = false
let ENABLE_SKIP_VERSION_CHECK_TOGGLE = false
let ENABLE_REPATCH_TOGGLE = true
let ENABLE_RESTORE = true
let SUPPORTED_CROSSOVER_VERSION = 22

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
let FILES_TO_DISABLE: [String] = [
    "/Contents/CodeResources",
    "/Contents/_CodeSignature",
]
let WINE_RESOURCES_ROOT = "Crossover"
let EXTERNAL_RESOURCES_ROOT = "gptk/redist"
let WINE_RESOURCES_PATHS: [String] = [
    "/lib64/libMoltenVK.dylib",
    "/lib64/wine/dxvk",
    "/lib/wine/dxvk",
    "/lib/wine/x86_32on64-unix/crypt32.so",
    "/lib/wine/x86_32on64-unix/ntdll.so",
    "/lib/wine/x86_32on64-unix/qcap.so",
    "/lib/wine/x86_32on64-unix/winegstreamer.so",
    "/lib/wine/x86_64-unix/crypt32.so",
    "/lib/wine/x86_64-unix/ntdll.so",
    "/lib/wine/x86_64-unix/qcap.so",
    "/lib/wine/x86_64-unix/winegstreamer.so",
    "/lib/wine/x86_64-unix/winemac.drv.so",
    "/lib/wine/i386-windows/advapi32.dll",
    "/lib/wine/i386-windows/api-ms-win-core-psm-appnotify-l1-1-0.dll",
    "/lib/wine/i386-windows/api-ms-win-power-base-l1-1-0.dll",
    "/lib/wine/i386-windows/atiadlxx.dll",
    "/lib/wine/i386-windows/crypt32.dll",
    "/lib/wine/i386-windows/kernel32.dll",
    "/lib/wine/i386-windows/kernelbase.dll",
    "/lib/wine/i386-windows/mfmediaengine.dll",
    "/lib/wine/i386-windows/mfplat.dll",
    "/lib/wine/i386-windows/mfreadwrite.dll",
    "/lib/wine/i386-windows/ntdll.dll",
    "/lib/wine/i386-windows/qcap.dll",
    "/lib/wine/i386-windows/quartz.dll",
    "/lib/wine/i386-windows/windows.gaming.input.dll",
    "/lib/wine/i386-windows/windows.gaming.ui.gamebar.dll",
    "/lib/wine/i386-windows/wined3d.dll",
    "/lib/wine/i386-windows/winegstreamer.dll",
    "/lib/wine/i386-windows/wintrust.dll",
    "/lib/wine/i386-windows/appwiz.cpl",
    "/lib/wine/i386-windows/mscoree.dll",
    "/lib/wine/x86_64-windows/advapi32.dll",
    "/lib/wine/x86_64-windows/api-ms-win-core-psm-appnotify-l1-1-0.dll",
    "/lib/wine/x86_64-windows/api-ms-win-power-base-l1-1-0.dll",
    "/lib/wine/x86_64-windows/atiadlxx.dll",
    "/lib/wine/x86_64-windows/crypt32.dll",
    "/lib/wine/x86_64-windows/kernel32.dll",
    "/lib/wine/x86_64-windows/kernelbase.dll",
    "/lib/wine/x86_64-windows/mfmediaengine.dll",
    "/lib/wine/x86_64-windows/mfplat.dll",
    "/lib/wine/x86_64-windows/mfreadwrite.dll",
    "/lib/wine/x86_64-windows/ntdll.dll",
    "/lib/wine/x86_64-windows/qcap.dll",
    "/lib/wine/x86_64-windows/quartz.dll",
    "/lib/wine/x86_64-windows/windows.gaming.input.dll",
    "/lib/wine/x86_64-windows/windows.gaming.ui.gamebar.dll",
    "/lib/wine/x86_64-windows/wined3d.dll",
    "/lib/wine/x86_64-windows/winegstreamer.dll",
    "/lib/wine/x86_64-windows/winemac.drv",
    "/lib/wine/x86_64-windows/wintrust.dll",
    "/lib/wine/x86_64-windows/appwiz.cpl",
    "/lib/wine/x86_64-windows/mscoree.dll",
    "/CrossOver-Hosted Application/wine64-preloader",
    "/share/crossover/bottle_data/crossover.inf",
    "/share/wine/wine.inf",
    "/share/wine/mono/wine-mono-7.4.1"
]

let BOTTLE_PATH_OVERRIDE = "/etc/CrossOver.conf"

let PLIST_PATH = "Contents/Info.plist"
