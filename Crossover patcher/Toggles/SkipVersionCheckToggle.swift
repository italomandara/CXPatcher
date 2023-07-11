//
//  SkipVersionCheckToggle.swift
//  CXPatcher
//
//  Created by Italo Mandara on 11/07/2023.
//

import Foundation
import SwiftUI

struct SkipVersionCheckToggle: View {
    @Binding var skipVersionCheck: Bool
    
    var body: some View {
        Toggle(isOn: $skipVersionCheck) {
            HStack(alignment: .center) {
                Image(systemName: "hazardsign.fill")
                Text(localizedCXPatcherString(forKey: "ForcePatch"))
                Spacer()
            }
        }
        .padding(.vertical, 6.0)
        .toggleStyle(.switch)
        .controlSize(/*@START_MENU_TOKEN@*/.mini/*@END_MENU_TOKEN@*/)
    }
}
