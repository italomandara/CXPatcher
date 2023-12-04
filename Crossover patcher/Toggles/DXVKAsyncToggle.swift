//
//  DXVKAsyncToggle.swift
//  CXPatcher
//
//  Created by Italo Mandara on 04/12/2023.
//

import Foundation
import SwiftUI

struct DXVKAsyncToggle: View {
    @Binding var opts: Opts
    
    var body: some View {
        Toggle(isOn: $opts.globalEnvs.dxvkAsync) {
            HStack(alignment: .center) {
                Text(localizedCXPatcherString(forKey: "DXVKAsyncToggle"))
                Spacer()
            }
        }
        .padding(.vertical, 6.0)
        .toggleStyle(.switch)
        .controlSize(/*@START_MENU_TOKEN@*/.mini/*@END_MENU_TOKEN@*/)
    }
}
