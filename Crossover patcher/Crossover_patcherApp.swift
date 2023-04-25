//
//  Crossover_patcherApp.swift
//  Crossover patcher
//
//  Created by Italo Mandara on 31/03/2023.
//

import SwiftUI

@main
struct Crossover_patcherApp: App {
    @State private var showingAlert = false
    @State private var message = ""
    
    var body: some Scene {
        WindowGroup {
            ContentView().fixedSize()
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Restore Crossover App"), message: Text(message), dismissButton: .default(Text("Cool!")))
            }
        }
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(after: .newItem) {
                Button("Restore") {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = false
                    panel.canChooseDirectories = false
                    let response =  panel.runModal()
                    if (response == .OK && panel.urls.first != nil){
                        if(isCrossoverApp(url: panel.url!) && isAlreadyPatched(url: panel.url!)) {
                            restoreApp(url: panel.url!.absoluteURL)
                            message = "Your App has been restored!"
                            showingAlert = true
                        } else {
                            message = "This isn't a patched Crossover App or the version of the patcher you used doesn't match"
                            showingAlert = true
                        }
                    }
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
