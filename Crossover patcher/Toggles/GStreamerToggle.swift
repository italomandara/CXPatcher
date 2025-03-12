//
//  GstreamerToggle.swift
//  CXPatcher
//
//  Created by Italo Mandara on 12/03/2025.
//

import Foundation
import SwiftUI

struct GStreamerToggle: View {
    @Binding var opts: Opts
    
    var body: some View {
        Toggle(isOn: $opts.patchGStreamer) {
            HStack(alignment: .center) {
                Image(systemName: "square.3.layers.3d.down.right")
                Text(localizedCXPatcherString(forKey: "Patch GStreamer"))
                Spacer()
            }
        }
        .padding(.vertical, 6.0)
        .toggleStyle(.switch)
        .disabled(opts.copyXtLibs)
        .controlSize(/*@START_MENU_TOKEN@*/.mini/*@END_MENU_TOKEN@*/)
    }
}
