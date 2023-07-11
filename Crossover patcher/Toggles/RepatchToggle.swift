//
//  RepatchToggle.swift
//  CXPatcher
//
//  Created by Italo Mandara on 11/07/2023.
//

import Foundation
import SwiftUI

struct RepatchToggle: View {
    @Binding var repatch: Bool
    
    var body: some View {
        Toggle(isOn: $repatch) {
            HStack(alignment: .center) {
                Image(systemName: "arrow.3.trianglepath")
                Text(localizedCXPatcherString(forKey: "AllowRepatchUpgradeToggle"))
                Spacer()
            }
        }
        .padding(.vertical, 6.0)
        .toggleStyle(.switch)
        .controlSize(/*@START_MENU_TOKEN@*/.mini/*@END_MENU_TOKEN@*/)
    }
}
