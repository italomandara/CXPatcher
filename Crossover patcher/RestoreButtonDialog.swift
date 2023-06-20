//
//  RestoreButtonDialog.swift
//  Crossover patcher
//
//  Created by Italo Mandara on 09/05/2023.
//

import SwiftUI

struct RestoreButtonDialog: View {
    @State private var showingAlert = false
    @State private var message = ""
    
    var body: some View {
        Button("Restore") {
            if let url = openAppSelectorPanel() {
                let restoreResult = restoreApp(url: url)
                if restoreResult {
                    message = "Your App has been restored!"
                    showingAlert = true
                } else {
                    message = "This isn't a patched Crossover App or the version of the patcher you used doesn't match"
                    showingAlert = true
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Restore Crossover App"), message: Text(message), dismissButton: .default(Text("Cool!")))
        }
    }
}
