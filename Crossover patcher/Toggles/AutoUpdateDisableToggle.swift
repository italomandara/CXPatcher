//
//  AutoUpdateDisableToggle.swift
//  CXPatcher
//
//  Created by Italo Mandara on 05/11/2023.
//

import Foundation
import SwiftUI

struct AutoUpdateDisableToggle: View {
    @Binding var opts: Opts
    
    var body: some View {
        Toggle(isOn: $opts.autoUpdateDisable) {
            HStack(alignment: .center) {
                Image(systemName: "arrow.triangle.2.circlepath.circle")
                Text(localizedCXPatcherString(forKey: "DisableAutoUpdate"))
                Spacer()
            }
        }
        .padding(.vertical, 6.0)
        .toggleStyle(.switch)
        .controlSize(/*@START_MENU_TOKEN@*/.mini/*@END_MENU_TOKEN@*/)
    }
}
