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
                if(!isTahoeOrBetter) {
                    HStack(alignment: .center) {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text("MacOS \(String(ProcessInfo().operatingSystemVersion.majorVersion)) \(localizedCXPatcherString(forKey: "unsupported"))")
                    }.foregroundColor(.red)
                }
            }
        }
        .padding(.vertical, 6.0)
        .toggleStyle(.switch)
        .controlSize(/*@START_MENU_TOKEN@*/.mini/*@END_MENU_TOKEN@*/)
        .disabled(
            !isTahoeOrBetter
        )
        .help(localizedCXPatcherString(forKey: "installExpMtlFXhelp"))
    }
}
