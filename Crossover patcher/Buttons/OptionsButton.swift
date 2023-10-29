//
//  OptionsButton.swift
//  CXPatcher
//
//  Created by Italo Mandara on 29/10/2023.
//

import Foundation
import SwiftUI
struct OptionsButton: View {
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        Button() {
            openWindow(id: "options")
        } label: {
            Image(systemName: "gear")
            Text(localizedCXPatcherString(forKey: "optionsButtonText"))
        }.padding(.top, 6.0)
    }
}
