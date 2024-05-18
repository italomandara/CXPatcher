//
//  ToolsButton.swift
//  CXPatcher
//
//  Created by Italo Mandara on 17/05/2024.
//

import Foundation
import SwiftUI
struct ToolsButton: View {
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        Button() {
            openWindow(id: "tools")
        } label: {
            Image(systemName: "folder.badge.gearshape")
            Text(localizedCXPatcherString(forKey: "toolsButtonText"))
        }.padding(.top, 6.0)
    }
}
