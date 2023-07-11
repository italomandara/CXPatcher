//
//  IntegrateExternalsToggle.swift
//  CXPatcher
//
//  Created by Italo Mandara on 11/07/2023.
//

import Foundation
import SwiftUI

struct IntegrateExternalsToggle: View {
    @Binding var integrateExternals: Bool
    @Binding var externalUrl: URL?
    
    var body: some View {
        Toggle(isOn: $integrateExternals) {
            HStack(alignment: .center) {
                Image(systemName: "wand.and.stars")
                Text(localizedCXPatcherString(forKey: "ExternalResourcesToggle"))
                Spacer()
            }
        }
        .padding(.vertical, 6.0)
        .toggleStyle(.switch)
        .controlSize(/*@START_MENU_TOKEN@*/.mini/*@END_MENU_TOKEN@*/)
        .disabled(isVentura)
        .help(isVentura ? "GPTK is supported on Sonoma only" : "Enables installation of D3dMetal")
        .onChange(of: integrateExternals) { value in
            if (value == false) {
                externalUrl = nil
            }
        }
    }
}
