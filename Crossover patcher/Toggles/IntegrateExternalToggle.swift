//
//  IntegrateExternalToggle.swift
//  CXPatcher
//
//  Created by Italo Mandara on 10/11/2024.
//

import Foundation
import SwiftUI

struct IntegrateExternalToggle: View {
    @Binding var opts: Opts
//    @Binding var externalUrl: URL?
    
    var body: some View {
        Toggle(isOn: $opts.copyExternal) {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Image(systemName: "wand.and.stars")
                    Text(localizedCXPatcherString(forKey: "ExternalResourcesToggle"))
                    Spacer()
                }
            }
        }.onChange(of: opts.copyExternal) { newValue in
            if (newValue == true) {
                opts.copyGptk = false
            }
        }
        .padding(.vertical, 6.0)
        .toggleStyle(.switch)
        .controlSize(/*@START_MENU_TOKEN@*/.mini/*@END_MENU_TOKEN@*/)
    }
}
