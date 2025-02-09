//
//  Untitled.swift
//  CXPatcher
//
//  Created by Italo Mandara on 30/11/2024.
//

import Foundation
import SwiftUI

struct DXMTOptions: View {
    @Binding var globalEnvs: GlobalEnvs
    @Binding var enabled: Bool
    var preferredMaxFrameRate: String {
        return $globalEnvs.preferredMaxFrameRate.wrappedValue < 30.0 ? "Disabled" : "\($globalEnvs.preferredMaxFrameRate.wrappedValue)"
    }
    var body: some View {
        VStack(alignment: .center) {
            Text(localizedCXPatcherString(forKey: "DXMTOptions"))
            VStack(alignment: .center) {
                Text(localizedCXPatcherString(forKey: "preferredMaxFrameRate", value: String(preferredMaxFrameRate)))
                Slider(
                    value: $globalEnvs.preferredMaxFrameRate,
                    in: 29...240,
                    step: 1.0
                )
                .help(localizedCXPatcherString(forKey: "preferredMaxFrameRateHelp"))
                .disabled(!enabled)
            }
            .padding(.vertical, 6.0)
            Toggle(isOn: $globalEnvs.metalFXSpatial) {
                HStack(alignment: .center) {
                    Text(localizedCXPatcherString(forKey:"metalFXSpatial"))
                    Spacer()
                }
            }
            .help(localizedCXPatcherString(forKey: "metalFXSpatialHelp"))
            .disabled(!enabled)
            .onChange(of: globalEnvs.metalFXSpatial) { newValue in
                if (!newValue) {
                    $globalEnvs.metalSpatialUpscaleFactor.wrappedValue = 1.0
                }
            }
            .padding(.vertical, 6.0)
            .toggleStyle(.switch)
            .controlSize(/*@START_MENU_TOKEN@*/.mini/*@END_MENU_TOKEN@*/)
            VStack(alignment: .center) {
                Text(localizedCXPatcherString(forKey:"metalSpatialUpscaleFactor", value: String($globalEnvs.metalSpatialUpscaleFactor.wrappedValue)))
                Slider(
                    value: $globalEnvs.metalSpatialUpscaleFactor,
                    in: 1.0...2.0,
                    step: 0.125
                )
                .help(localizedCXPatcherString(forKey: "metalFXSpatialHelp"))
                .disabled(!globalEnvs.metalFXSpatial || !enabled)
            }
            .padding(.vertical, 6.0)
        }
        .onChange(of: enabled) { newValue in
            if (!newValue) {
                globalEnvs.metalFXSpatial = false
                globalEnvs.preferredMaxFrameRate = 29.00
            }
        }
        .opacity(enabled ? 1 : 0.5)
        .padding(.top, 20)
    }
}

struct DXMTOptions_Previews: PreviewProvider {
    static var previews: some View {
        @State var globalEnvs = GlobalEnvs()
        @State var enabled: Bool = true
        DXMTOptions(globalEnvs: $globalEnvs, enabled: $enabled)
    }
}
