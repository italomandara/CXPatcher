//
//  ExternalResButton.swift
//  Crossover patcher
//
//  Created by Italo Mandara on 15/06/2023.
//

import SwiftUI

struct XtLibsUrlButtonDialog: View {
    @Binding var XtLibsUrl: URL?
    var body: some View {
        if(XtLibsUrl != nil) {
            Text("\(localizedCXPatcherString(forKey: "XtLibsPathLabelText")): \(XtLibsUrl!.path)")
        } else {
            Button(localizedCXPatcherString(forKey: "XtLibsButtonText")) {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = true
                panel.canChooseFiles = false
                let response =  panel.runModal()
                if (response == .OK && panel.urls.first != nil){
                    XtLibsUrl = panel.urls.first!
                } else {
                    console.log("aborted by user")
                }
            }.buttonStyle(.borderedProminent)
        }
    }
}
