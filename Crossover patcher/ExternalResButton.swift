//
//  ExternalResButton.swift
//  Crossover patcher
//
//  Created by Italo Mandara on 15/06/2023.
//

import SwiftUI

struct ExternalResButtonDialog: View {
    @Binding var externalUrl: URL?
    var body: some View {
        if(externalUrl != nil) {
            Text("\(localizedCXPatcherString(forKey: "ExternalResourcesPathLabelText")): \(externalUrl!.path)")
        } else {
            Button(localizedCXPatcherString(forKey: "ExternalResourcesButtonText")) {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = true
                panel.canChooseFiles = false
                let response =  panel.runModal()
                if (response == .OK && panel.urls.first != nil){
                    externalUrl = panel.urls.first!
                } else {
                    print("aborted by user")
                }
            }.buttonStyle(.borderedProminent)
        }
    }
}
