//
//  DisableUE4HackToggle.swift
//  CXPatcher
//
//  Created by Italo Mandara on 08/12/2023.
//

import Foundation
import SwiftUI

struct DisableUE4HackToggle: View {
    @Binding var opts: Opts
    
    var body: some View {
        Toggle(isOn: $opts.globalEnvs.disableUE4Hack) {
            HStack(alignment: .center) {
                Text(localizedCXPatcherString(forKey: "DisableUE4HackToggle"))
                Spacer()
            }
        }
        .padding(.vertical, 6.0)
        .toggleStyle(.switch)
        .controlSize(/*@START_MENU_TOKEN@*/.mini/*@END_MENU_TOKEN@*/)
    }
}
