//
//  Config.swift
//  Crossover patcher
//
//  Created by Italo Mandara on 24/06/2023.
//

import Foundation

private let USER_DEFAULTS = UserDefaults.standard

let SKIP_VENTURA_CHECK = false || USER_DEFAULTS.bool(forKey: "SKIP_VENTURA_CHECK")
let SKIP_DISCLAIMER_CHECK = false  || USER_DEFAULTS.bool(forKey: "SKIP_DISCLAIMER_CHECK")
let ENABLE_SKIP_VERSION_CHECK_TOGGLE = false || USER_DEFAULTS.bool(forKey: "ENABLE_SKIP_VERSION_CHECK_TOGGLE")
let ENABLE_REPATCH_TOGGLE = true
let ENABLE_RESTORE = true
