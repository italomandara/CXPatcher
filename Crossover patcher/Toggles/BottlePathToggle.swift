//
//  BottlePathToggle.swift
//  CXPatcher
//
//  Created by Italo Mandara on 11/07/2023.
//

import Foundation
import SwiftUI

struct BottlesPathToggle: View {
    @Binding var sepBottlePath: Bool
//    @Binding var externalUrl: URL?
    
    var body: some View {
        Toggle(isOn: $sepBottlePath) {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Image(systemName: "waterbottle")
                    Text(localizedCXPatcherString(forKey: "bottlesPathToggle"))
                    Spacer()
                }
            }
        }
        .padding(.vertical, 6.0)
        .toggleStyle(.switch)
        .controlSize(/*@START_MENU_TOKEN@*/.mini/*@END_MENU_TOKEN@*/)
        .disabled(isVentura)
    }
}
