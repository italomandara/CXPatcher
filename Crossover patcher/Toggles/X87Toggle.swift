//
//  X87Toggle.swift
//  CXPatcher
//
//  Created by Italo Mandara on 16/02/2026.
//

import SwiftUI

struct X87Toggle: View {
    @Binding var opts: Opts
    
    var body: some View {
        Toggle(isOn: $opts.globalEnvs.x87Enabled) {
            HStack(alignment: .center) {
                Text(localizedCXPatcherString(forKey: "X87Toggle"))
                Spacer()
            }
        }
        .padding(.vertical, 6.0)
        .toggleStyle(.switch)
        .controlSize(/*@START_MENU_TOKEN@*/.mini/*@END_MENU_TOKEN@*/)
    }
}
