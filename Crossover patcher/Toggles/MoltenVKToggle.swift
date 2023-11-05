//
//  MoltenVKToggle.swift
//  CXPatcher
//
//  Created by Italo Mandara on 24/10/2023.
//
import Foundation
import SwiftUI

struct MoltenVKToggle: View {
    @Binding var opts: Opts
    
    var body: some View {
        Toggle(isOn: $opts.patchMVK) {
            HStack(alignment: .center) {
                Image(systemName: "square.3.layers.3d.down.right")
                Text(localizedCXPatcherString(forKey: "Patch MoltenVK"))
                Spacer()
            }
        }
        .padding(.vertical, 6.0)
        .toggleStyle(.switch)
        .controlSize(/*@START_MENU_TOKEN@*/.mini/*@END_MENU_TOKEN@*/)
    }
}
