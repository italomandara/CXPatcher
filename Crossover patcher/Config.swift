//
//  Config.swift
//  Crossover patcher
//
//  Created by Italo Mandara on 24/06/2023.
//

import Foundation

let SKIP_VENTURA_CHECK = false
let ENABLE_CLEAR_D3DMETAL_CACHE = true
let ENABLE_CLEAR_STEAM_CACHE = true
let D3DM_CACHE_FOLDER = "d3dm"
let ENABLE_FIX_CX_CODESIGN = true
let ENABLE_EXTERNAL_RESOURCES = true
enum UIGlobals: CGFloat {
    case radius = 10.00
}

#if DEBUG
let SKIP_DISCLAIMER_CHECK = true
#else
let SKIP_DISCLAIMER_CHECK = false
#endif

let ENABLE_SKIP_VERSION_CHECK_TOGGLE = false

let ENABLE_RESTORE = false
let ENABLE_REPATCH_TOGGLE = ENABLE_RESTORE
let ENABLE_BACKUP = !ENABLE_RESTORE

let SUPPORTED_CROSSOVER_VERSION = "25"
let ENABLE_GSTREAMER = true

let DEFAULT_BOTTLE_PATH = "/Library/Application Support/CrossOver/Bottles/"
let SHARED_SUPPORT_COMPONENT = "Contents/SharedSupport/CrossOver"
let SHARED_SUPPORT_PATH = "/" + SHARED_SUPPORT_COMPONENT
let DEFAULT_CX_BOTTLES_ROOTPATH = "/Users/${USER}/"
let DEFAULT_CX_BOTTLES_FOLDER = "CXPBottles"
let DEFAULT_CX_BOTTLES_PATH = DEFAULT_CX_BOTTLES_ROOTPATH + DEFAULT_CX_BOTTLES_FOLDER
let LIB_PATH = "/lib/"

let EXTERNAL_RESOURCES_ROOT = "/lib64/apple_gptk"
let EXTERNAL_WINE_PATHS: [String] = [
    "/external",
    "/wine/x86_64-unix/atidxx64.so",
    "/wine/x86_64-unix/d3d11.so",
    "/wine/x86_64-unix/d3d12.so",
    "/wine/x86_64-unix/dxgi.so",
    "/wine/x86_64-windows/atidxx64.dll",
    "/wine/x86_64-windows/d3d11.dll",
    "/wine/x86_64-windows/d3d12.dll",
    "/wine/x86_64-windows/dxgi.dll",
]

let BUILTIN_LIBS_GSTREAMER = [
    "/Contents/SharedSupport/CrossOver/lib/gstreamer-1.0",
    "/Contents/SharedSupport/CrossOver/lib/libffi.8.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libffi.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgio-2.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgio-2.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libglib-2.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libglib-2.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgmodule-2.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgmodule-2.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgobject-2.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgobject-2.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstadaptivedemux-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstadaptivedemux-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstallocators-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstallocators-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstapp-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstapp-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstaudio-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstaudio-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstbadaudio-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstbadaudio-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstbase-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstbase-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstbasecamerabinsrc-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstbasecamerabinsrc-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstcodecparsers-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstcodecparsers-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstcodecs-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstcodecs-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstcontroller-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstcontroller-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstfft-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstfft-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstgl-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstgl-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstinsertbin-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstinsertbin-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstisoff-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstisoff-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstmpegts-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstmpegts-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstnet-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstnet-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstpbutils-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstpbutils-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstphotography-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstphotography-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstplay-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstplay-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstplayer-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstplayer-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstreamer-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstreamer-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstriff-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstriff-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstrtp-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstrtp-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstrtsp-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstrtsp-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstsctp-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstsctp-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstsdp-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstsdp-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgsttag-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgsttag-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgsttranscoder-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgsttranscoder-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgsturidownloader-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgsturidownloader-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstvideo-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstvideo-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstwebrtc-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgstwebrtc-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgthread-2.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libgthread-2.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libintl.8.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libintl.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libpcre2-8.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libpcre2-8.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libpcre2-posix.3.dylib",
    "/Contents/SharedSupport/CrossOver/lib/libpcre2-posix.dylib",
]

let BUILTIN_LIBS_GSTREAMER64 = [
    "/Contents/SharedSupport/CrossOver/lib64/libgmodule-2.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgthread-2.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstplayer-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstaudio-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstsdp-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstmpegts-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstnet-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstmpegts-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstrtsp-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libffi.8.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstreamer-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgsttranscoder-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstisoff-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstphotography-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstsdp-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstplay-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstplay-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgobject-2.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstreamer-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstcodecs-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libpcre2-8.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstwebrtc-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstcontroller-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstcodecparsers-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstbadaudio-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libglib-2.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstrtp-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstwebrtc-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgsttag-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstinsertbin-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstisoff-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstfft-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstbadaudio-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgio-2.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libglib-2.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgobject-2.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgsttag-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstvideo-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgsttranscoder-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstrtp-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/gstreamer-1.0",
    "/Contents/SharedSupport/CrossOver/lib64/libgstanalytics-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstanalytics-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstmse-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstmse-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstapp-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstrtsp-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libintl.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstvideo-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstfft-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstadaptivedemux-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgmodule-2.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstbasecamerabinsrc-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstsctp-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libintl.8.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstphotography-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgsturidownloader-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstpbutils-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstbase-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstallocators-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libpcre2-posix.3.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libffi.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstcontroller-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstcodecparsers-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgthread-2.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libpcre2-8.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstriff-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstadaptivedemux-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstnet-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstriff-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgsturidownloader-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstbasecamerabinsrc-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstaudio-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstinsertbin-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstcodecs-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstbase-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstgl-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstgl-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstallocators-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstplayer-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstpbutils-1.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libpcre2-posix.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstsctp-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgstapp-1.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/libgio-2.0.0.dylib",
    "/Contents/SharedSupport/CrossOver/lib64/gstreamer-1.0",
]

let FILES_TO_REMOVE: [String] = [
    "/Contents/CodeResources",
    "/Contents/_CodeSignature",
]

let WINE_RESOURCES_ROOT = "Crossover"

let MOLTENVK_BASELINE = "/lib64/libMoltenVK.dylib"
let MOLTENVK_LATEST = "/lib64/libMoltenVK-latest.dylib"
let MOLTENVK_EXPERIMENTAL = "/lib64/libMoltenVK-experimental.dylib"

let WINE_GSTREAMER_RESOURCES_PATHS: [String] = [
    "/lib/wine/x86_64-unix/winegstreamer.so",
]

let WINE_DXMT_RESOURCES_PATHS: [String] = [
    "/lib/wine/i386-windows/winemetal.dll",
    "/lib/wine/x86_64-windows/winemetal.dll",
]

let WINE_DXVK_RESOURCES_PATHS: [String] = [
    "/lib/dxvk/i386-windows/d3d10core.dll",
    "/lib/dxvk/i386-windows/d3d11.dll",
    "/lib/dxvk/x86_64-windows/d3d10core.dll",
    "/lib/dxvk/x86_64-windows/d3d11.dll",
]

let WINE_WINEINF_PATH: String = "/share/wine/wine.inf"


let WINE_RESOURCES_PATHS: [String] = [
    //    "/lib64/libinotify.0.dylib",
    //    "/lib64/libinotify.dylib",
    //    "/lib/wine/i386-windows/kernelbase.dll",
    //    "/lib/wine/i386-windows/ntdll.dll",
    //    "/lib/wine/i386-windows/winegstreamer.dll",
    //    "lib/wine/i386-windows/wineboot.exe",
    //    "/lib/wine/i386-windows/winecfg.exe",
    //    "/lib/wine/x86_64-unix/ntdll.so",
    //    "/lib/wine/x86_64-windows/kernelbase.dll",
    //    "/lib/wine/x86_64-windows/ntdll.dll",
    //    "/lib/wine/x86_64-windows/wineboot.exe",
    //    "/lib/wine/x86_64-windows/winecfg.exe",
        "/share/crossover/bottle_data/crossover.inf",
    //    "/CrossOver-Hosted Application/wineserver",
]
//+ [MOLTENVK_BASELINE]
//+ [WINE_WINEINF_PATH]
//+ WINE_DXVK_RESOURCES_PATHS
//+ WINE_GSTREAMER_RESOURCES_PATHS
//+ WINE_DXMT_RESOURCES_PATHS
    
let DXMT_PATHS = [
    PathMap(src: "src/winemetal/unix/winemetal.so", dst: "/lib/dxmt/x86_64-unix/winemetal.so"),
    PathMap(src: "src/winemetal/winemetal.dll", dst: "/lib/dxmt/x86_64-windows/winemetal.dll"),
    PathMap(src: "src/dxgi/dxgi.dll", dst: "/lib/dxmt/x86_64-windows/dxgi.dll"),
    PathMap(src: "src/d3d11/d3d11.dll", dst: "/lib/dxmt/x86_64-windows/d3d11.dll"),
    PathMap(src: "src/d3d10/d3d10core.dll", dst: "/lib/dxmt/x86_64-windows/d3d10core.dll"),
]

let DXMT_PATHS_RELEASE = [
    PathMap(src: "x86_64-unix/winemetal.so", dst: "/lib/dxmt/x86_64-unix/winemetal.so"),
    PathMap(src: "x86_64-windows/winemetal.dll", dst: "/lib/dxmt/x86_64-windows/winemetal.dll"),
    PathMap(src: "x86_64-windows/dxgi.dll", dst: "/lib/dxmt/x86_64-windows/dxgi.dll"),
    PathMap(src: "x86_64-windows/d3d11.dll", dst: "/lib/dxmt/x86_64-windows/d3d11.dll"),
    PathMap(src: "x86_64-windows/d3d10core.dll", dst: "/lib/dxmt/x86_64-windows/d3d10core.dll"),
    PathMap(src: "i386-windows/winemetal.dll", dst: "/lib/dxmt/i386-windows/winemetal.dll"),
    PathMap(src: "i386-windows/dxgi.dll", dst: "/lib/dxmt/i386-windows/dxgi.dll"),
    PathMap(src: "i386-windows/d3d11.dll", dst: "/lib/dxmt/i386-windows/d3d11.dll"),
    PathMap(src: "i386-windows/d3d10core.dll", dst: "/lib/dxmt/i386-windows/d3d10core.dll"),
]

struct ToBottlesPaths {
    var fileName: String
    var path: String
    var fullPath: String {
        return path + fileName
    }
}

let DXMT_EVERY_BOTTLE_SYS_PATHS = [
    ToBottlesPaths(
        fileName: "winemetal.dll",
        path: "src/winemetal/"
    )
]

let BOTTLE_PATH_OVERRIDE = "/etc/CrossOver.conf"

let PLIST_PATH = "Contents/Info.plist"
