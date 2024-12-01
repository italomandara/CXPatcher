//
//  Options.swift
//  CXPatcher
//
//  Created by Italo Mandara on 29/10/2023.
//

import Foundation
import SwiftUI

struct Options: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openWindow) var openWindow
    @Binding var opts: Opts
    var body: some View {
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
                ).help(localizedCXPatcherString(forKey: "ExternalsToggleHelp"))
                if(opts.copyXtLibs) {
                    XtLibsUrlSelector(XtLibsUrl: $opts.xtLibsUrl)
                }
            }
            DXVKToggle(
                opts: $opts
            )
            .help(localizedCXPatcherString(forKey: "dxvkToggleHelp"))
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
            DisableUE4HackToggle(
                opts: $opts
            )
            .help(localizedCXPatcherString(forKey: "DisableUE4HackToggleHelp"))
            Divider().padding(.vertical, 2)
            DXMTOptions(globalEnvs: $opts.globalEnvs, enabled: $opts.copyXtLibs)
        }.padding(20)
        .frame(width: 400.0)
        .fixedSize()
    }

}

struct Options_Previews: PreviewProvider {
    static var previews: some View {
        @State var opts = Opts(copyXtLibs: true)
        Options(opts: $opts)
    }
}
