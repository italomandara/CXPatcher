//
//  Crossover_patcherApp.swift
//  Crossover patcher
//
//  Created by Italo Mandara on 31/03/2023.
//

import SwiftUI
import Cocoa

@main
struct Crossover_patcherApp: App {
    @State private var opts = Opts()
    
    var body: some Scene {
        WindowGroup {
            ContentView(opts: $opts).fixedSize()
        }
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(after: .newItem) {
                if(ENABLE_RESTORE) {
                    RestoreButtonDialog(opts: opts)
                }
            }
        }
        
        Window(localizedCXPatcherString(forKey: "Instructions"), id: "instructions") {
            Instructions()
                .fixedSize()
        }
        .windowResizability(.contentSize)
        
        Window(localizedCXPatcherString(forKey: "Options"), id: "options") {
            Options(opts: $opts)
        }
        .windowResizability(.contentSize)
        

        Window(localizedCXPatcherString(forKey: "toolsButtonText"), id: "tools") {
            Tools().fixedSize()
        }
        .windowResizability(.contentSize)
    }
}
