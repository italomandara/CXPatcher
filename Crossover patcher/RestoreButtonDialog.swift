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
                    message = localizedCXPatcherString(forKey: "RestoreSuccess")
                    showingAlert = true
                } else {
                    message = localizedCXPatcherString(forKey: "RestoreFailure")
                    showingAlert = true
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(localizedCXPatcherString(forKey: "RestoreStatusLabel")), message: Text(message), dismissButton: .default(Text(localizedCXPatcherString(forKey: "RestoreConfirm"))))
        }
    }
}
