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
        Picker(selection: $opts.patchMVK, label:
            HStack(alignment: .center) {
                Image(systemName: "square.3.layers.3d.down.right")
                Text(localizedCXPatcherString(forKey: "Patch MoltenVK"))
            }
        ) {
            Text(localizedCXPatcherString(forKey:"MVKdontPatch")).tag(PatchMVK.none)
            Text(localizedCXPatcherString(forKey:"MVKbaseline")).tag(PatchMVK.legacyUE4)
            Text(localizedCXPatcherString(forKey:"MVKexperimental")).tag(PatchMVK.latestUE4)
        }.pickerStyle(.menu)
        .padding(.vertical, 6.0)
    }
}

struct MoltenVKToggle_Previews: PreviewProvider {
    static var previews: some View {
        @State var opts = Opts()
        MoltenVKToggle(opts: $opts)
    }
}
