//
//  Options.swift
//  CXPatcher
//
//  Created by Italo Mandara on 29/10/2023.
//

import Foundation
import SwiftUI

struct Options: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openWindow) var openWindow
    @Binding var opts: Opts
    @State var showXTLibsModal: Bool = false
    @State var DXMTOptionsEnabled: Bool = false
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                if(showXTLibsModal) {
                    VStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(colorScheme == .light ? .white: .gray)
                            .frame(width: 340, height: 500)
                            .overlay(
                                VStack(alignment: .center) {
                                    XtLibsUrlSelector(XtLibsUrl: $opts.xtLibsUrl).onChange(of: opts.xtLibsUrl) { newValue in
                                        if(newValue != nil) {
                                            DXMTOptionsEnabled = true
                                        }
                                    }
                                    DXMTOptions(globalEnvs: $opts.globalEnvs, enabled: $DXMTOptionsEnabled)
                                    if(opts.xtLibsUrl != nil) {
                                        Button("OK") {
                                            showXTLibsModal = false
                                        }
                                        .buttonStyle(.borderedProminent)
                                        .padding(.top, 20)
                                    }
                                }.padding(20)
                            )
                    }
                    .zIndex(10)
                    .frame(width: 400, height: 800)
                    .fixedSize(horizontal: false, vertical: true)
                    .background(colorScheme == .light ? .white.opacity(0.85): .black.opacity(0.85))
                    .shadow(radius: 20)
                }
                VStack(alignment: .center) {
                    MoltenVKToggle(
                        opts: $opts
                    )
                    .help(localizedCXPatcherString(forKey: "mkvToggleHelp"))
                    IntegrateGPTKToggle(
                        opts: $opts
                    ).help(localizedCXPatcherString(forKey: "gptkToggleHelp"))
                    if(ENABLE_EXTERNAL_RESOURCES) {
                        XtLibsToggle(
                            opts: $opts
                        )
                        .help(localizedCXPatcherString(forKey: "ExternalsToggleHelp"))
                        .onChange(of: opts.copyXtLibs) { enabled in
                            showXTLibsModal = enabled
                        }
                    }
                    DXVKToggle(
                        opts: $opts
                    )
                    .help(localizedCXPatcherString(forKey: "dxvkToggleHelp"))
                    GStreamerToggle(
                        opts: $opts
                    )
                    .help(localizedCXPatcherString(forKey: "GStreamerToggleHelp"))
                    BottlesPathToggle(
                        opts: $opts
                    )
                    RemoveSignatureToggle(
                        opts: $opts
                    )
                    .help(localizedCXPatcherString(forKey: "signatureToggleHelp"))
                    AutoUpdateDisableToggle(
                        opts: $opts
                    )
                    .help(localizedCXPatcherString(forKey: "autoUpdateToggleHelp"))
                    Divider().padding(.vertical, 2)
                    Text(localizedCXPatcherString(forKey: "Environment Globals")).padding(.top, 2)
                    AdvertiseAVXToggle(
                        opts: $opts
                    )
                    .help(localizedCXPatcherString(forKey: "advertiseAVXToggleHelp"))
                    DXVKAsyncToggle(
                        opts: $opts
                    )
                    .help(localizedCXPatcherString(forKey: "DXVKAsyncToggleHelp"))
                    FastMathToggle(
                        opts: $opts
                    )
                    .help(localizedCXPatcherString(forKey: "fastMathToggleHelp"))
                    MTLHUDToggle(
                        opts: $opts
                    )
                    .help(localizedCXPatcherString(forKey: "hudToggleHelp"))
//                    DisableUE4HackToggle(
//                        opts: $opts
//                    )
//                    .help(localizedCXPatcherString(forKey: "DisableUE4HackToggleHelp"))
//                    Divider().padding(.vertical, 2)
                }
                .padding(20)
                .frame(width: 400.0)
            }
            .frame(maxHeight: 700)
        }
        .frame(maxHeight: 700)
        .background(Color.white.opacity(0.5))
    }
}

struct Options_Previews: PreviewProvider {
    static var previews: some View {
        @State var opts = Opts(copyXtLibs: true)
        Options(opts: $opts)
    }
}
