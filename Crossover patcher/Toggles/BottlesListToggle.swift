//
//  BottlesList.swift
//  CXPatcher
//
//  Created by Italo Mandara on 13/06/2025.
//
import Foundation
import SwiftUI

struct BottlesList: View {
    @Binding var list: [URL]
    @Binding var opts: Opts
    var body: some View {
        Picker(selection: $opts.targetBottlePath, label:
                Text(localizedCXPatcherString(forKey: "Install MetalFX libs in this bottle:"))
        ) {
            Text(localizedCXPatcherString(forKey: "Please select an option")).tag("")
            ForEach(list, id: \.self ) { url in
                Text(url.lastPathComponent).tag(url.relativePath)
            }
        }
        .pickerStyle(.menu)
        .padding(.bottom, 6.0)
    }
}
