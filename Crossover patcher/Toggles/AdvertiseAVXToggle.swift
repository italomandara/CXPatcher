//
//  AdvertiseAVX.swift
//  CXPatcher
//
//  Created by Italo Mandara on 17/07/2024.
//

import Foundation
import SwiftUI

struct AdvertiseAVXToggle: View {
    @Binding var opts: Opts
    
    var body: some View {
        Toggle(isOn: $opts.globalEnvs.advertiseAVX) {
            HStack(alignment: .center) {
                Text(localizedCXPatcherString(forKey: "advertiseAVXToggle"))
                Spacer()
            }
        }
        .padding(.vertical, 6.0)
        .toggleStyle(.switch)
        .controlSize(/*@START_MENU_TOKEN@*/.mini/*@END_MENU_TOKEN@*/)
    }
}
