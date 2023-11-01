//
//  Config.swift
//  Crossover patcher
//
//  Created by Italo Mandara on 24/06/2023.
//

import Foundation

let SKIP_VENTURA_CHECK = false

#if DEBUG
    let SKIP_DISCLAIMER_CHECK = true
#else
    let SKIP_DISCLAIMER_CHECK = false
#endif

let ENABLE_SKIP_VERSION_CHECK_TOGGLE = false

let ENABLE_REPATCH_TOGGLE = true
let ENABLE_RESTORE = true

let SUPPORTED_CROSSOVER_VERSION = "23."
let ENABLE_GSTREAMER = false

let SHARED_SUPPORT_PATH = "/Contents/SharedSupport/CrossOver"
let DEFAULT_CX_BOTTLES_PATH = "/Users/${USER}/CXPBottles"
let LIB_PATH = "/lib/"

let EXTERNAL_RESOURCES_ROOT = "/lib64/apple_gpt"
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
let FILES_TO_DISABLE: [String] = [
    "/Contents/CodeResources",
    "/Contents/_CodeSignature",
//    "/Contents/SharedSupport/CrossOver/lib64/gstreamer-1.0",
//    "/Contents/SharedSupport/CrossOver/lib/gstreamer-1.0",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstapp-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstapp-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstsctp-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstsctp-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstallocators-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstallocators-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstaudio-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstaudio-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstbase-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstbase-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstbasecamerabinsrc-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstbasecamerabinsrc-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstcodecs-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstcodecs-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstgl-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstgl-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstgl-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstgl-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstinsertbin-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstinsertbin-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstpbutils-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstpbutils-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstplayer-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstplayer-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgsturidownloader-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgsturidownloader-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstadaptivedemux-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstadaptivedemux-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstallocators-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstallocators-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstbase-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstbase-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstcodecparsers-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstcodecparsers-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstcontroller-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstcontroller-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstnet-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstnet-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstpbutils-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstpbutils-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstriff-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstriff-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstriff-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstriff-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstadaptivedemux-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstadaptivedemux-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstbasecamerabinsrc-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstbasecamerabinsrc-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstfft-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstfft-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstphotography-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstphotography-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstrtsp-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstrtsp-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstsctp-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstsctp-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgsturidownloader-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgsturidownloader-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstvideo-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstvideo-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstapp-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstapp-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstapplemedia.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstasf.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstaudioconvert.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstaudioresample.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstavi.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstcoreelements.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstdeinterlace.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstid3demux.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstopengl.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgsttypefindfunctions.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstvideoconvertscale.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstvideoparsersbad.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstaudioparsers.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstbadaudio-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstbadaudio-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstisomp4.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstplayback.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstrtp-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstrtp-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgsttag-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgsttag-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgsttranscoder-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgsttranscoder-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstvideo-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstvideo-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstvideofilter.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstwavparse.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstbadaudio-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstbadaudio-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstcodecparsers-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstcodecparsers-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstcontroller-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstcontroller-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstfft-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstfft-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstinsertbin-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstinsertbin-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstisoff-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstisoff-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstrtp-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstrtp-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgsttag-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgsttag-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstwebrtc-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstwebrtc-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstcodecs-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstcodecs-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstisoff-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstisoff-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstphotography-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstphotography-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstplay-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstplay-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstplay-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstplay-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstreamer-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstreamer-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstsdp-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstsdp-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgsttranscoder-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgsttranscoder-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstwebrtc-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstwebrtc-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstaudio-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstaudio-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstmpegts-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstmpegts-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstmpegts-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstmpegts-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstnet-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstnet-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstplayer-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstplayer-1.0.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstreamer-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstreamer-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstrtsp-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstrtsp-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstsdp-1.0.dylib",
//    "/Contents/SharedSupport/CrossOver/lib64/libgstsdp-1.0.dylib",
]
let WINE_RESOURCES_ROOT = "Crossover"
let WINE_RESOURCES_PATHS: [String] = [
    "/lib64/libMoltenVK.dylib",
    "/lib64/wine/dxvk",
    "/lib/wine/dxvk",
    "/lib/wine/i386-windows/kernelbase.dll",
    "/lib/wine/i386-windows/ntdll.dll",
//    "/lib/wine/i386-windows/winegstreamer.dll",
    "/lib/wine/x86_64-unix/ntdll.so",
//    "/lib/wine/x86_64-unix/winegstreamer.so",
    "/lib/wine/x86_64-windows/kernelbase.dll",
    "/lib/wine/x86_64-windows/ntdll.dll",
//    "/lib/wine/x86_64-windows/winegstreamer.dll",
    "/share/crossover/bottle_data/crossover.inf",
    "/CrossOver-Hosted Application/wineserver"
//    "/share/wine/wine.inf",
]

let BOTTLE_PATH_OVERRIDE = "/etc/CrossOver.conf"

let PLIST_PATH = "Contents/Info.plist"
