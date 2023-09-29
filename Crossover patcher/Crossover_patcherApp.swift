//
//  Crossover_patcherApp.swift
//  Crossover patcher
//
//  Created by Italo Mandara on 31/03/2023.
//

import SwiftUI

@main
struct Crossover_patcherApp: App {    
    @State private var opts = Opts()
    var body: some Scene {
        WindowGroup {
            ContentView(opts: opts).fixedSize()
        }
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(after: .newItem) {
                if(ENABLE_RESTORE) {
                    RestoreButtonDialog(opts: opts)
                }
            }
        }
        Window("Instructions", id: "instructions") {
            Instructions().fixedSize()
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
    }
}
