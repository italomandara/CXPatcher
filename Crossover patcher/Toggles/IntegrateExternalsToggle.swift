//
//  IntegrateExternalsToggle.swift
//  CXPatcher
//
//  Created by Italo Mandara on 11/07/2023.
//

import Foundation
import SwiftUI

struct IntegrateExternalsToggle: View {
    @Binding var copyGptk: Bool
//    @Binding var externalUrl: URL?
    
    var body: some View {
        Toggle(isOn: $copyGptk) {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Image(systemName: "wand.and.stars")
                    Text(localizedCXPatcherString(forKey: "ExternalResourcesToggle"))
                    Spacer()
                }
                if(isVentura) {
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
        .disabled(isVentura)
        .help(isVentura ? "GPTK is supported on Sonoma only" : "Enables installation of D3dMetal")
//        .onChange(of: copyGptk) { value in
//            if (value == false) {
//                externalUrl = nil
//            }
//        }
    }
}
