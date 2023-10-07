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
let SUPPORTED_CROSSOVER_VERSION = 23.5
let ENABLE_GSTREAMER = false

let SHARED_SUPPORT_PATH = "/Contents/SharedSupport/CrossOver"
let LIB_PATH = "/lib/"

let EXTERNAL_RESOURCES_ROOT = "/lib64/apple_gpt"
let EXTERNAL_WINE_PATHS: [String] = [
    "/external",
    "/wine",
]
let FILES_TO_DISABLE: [String] = [
    "/Contents/CodeResources",
    "/Contents/_CodeSignature",
]
let WINE_RESOURCES_ROOT = "Crossover"
let WINE_RESOURCES_PATHS: [String] = [
    "/lib64/libMoltenVK.dylib",
    "/lib64/wine/dxvk",
    "/lib/wine/dxvk",
    "/share/crossover/bottle_data/crossover.inf",
//    "/share/wine/wine.inf",
]

let BOTTLE_PATH_OVERRIDE = "/etc/CrossOver.conf"

let PLIST_PATH = "Contents/Info.plist"
