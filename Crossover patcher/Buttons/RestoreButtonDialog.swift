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
    @State var opts: Opts
    
    var body: some View {
        Button {
            if let url = openAppSelectorPanel() {
                let restoreResult = restoreApp(url: url, opts: &opts)
                if restoreResult {
                    message = localizedCXPatcherString(forKey: "RestoreSuccess")
                    showingAlert = true
                } else {
                    message = localizedCXPatcherString(forKey: "RestoreFailure")
                    showingAlert = true
                }
            }
        } label: {
            Image(systemName: "arrow.uturn.backward")
            Text(localizedCXPatcherString(forKey: "RestoreButtonLabel"))
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(localizedCXPatcherString(forKey: "RestoreStatusLabel")), message: Text(message), dismissButton: .default(Text(localizedCXPatcherString(forKey: "RestoreConfirm"))))
        }
    }
}
