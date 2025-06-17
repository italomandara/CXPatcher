//
//  GPTKExpMtlFXToggle.swift
//  CXPatcher
//
//  Created by Italo Mandara on 12/06/2025.
//

import Foundation
import SwiftUI

struct GPTKExpMtlFXToggle: View {
    @Binding var opts: Opts
    
    var body: some View {
        Toggle(isOn: $opts.enableExpMtlFX) {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Image(systemName: "slider.horizontal.3")
                    Text(localizedCXPatcherString(forKey: "enableExpMtlFX"))
                    Spacer()
                }
                if(!shouldD3dMSupportMetalFX) {
                    HStack(alignment: .center) {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text("MacOS \(String(ProcessInfo().operatingSystemVersion.majorVersion)) \(localizedCXPatcherString(forKey: "unsupported"))")
                    }.foregroundColor(.red)
                }
                HStack(alignment: .center) {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text((localizedCXPatcherString(forKey: "Works only on M3 or better CPUs")))
                }.foregroundColor(.yellow)
            }
        }
        .padding(.vertical, 6.0)
        .toggleStyle(.switch)
        .controlSize(/*@START_MENU_TOKEN@*/.mini/*@END_MENU_TOKEN@*/)
        .disabled(
            !shouldD3dMSupportMetalFX
        )
        .help(localizedCXPatcherString(forKey: "installExpMtlFXhelp"))
    }
}
