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
//            IntegrateExternalsToggle(
//                copyGptk: $opts.copyGptk
//            )
//            .help(localizedCXPatcherString(forKey: "gptkToggleHelp"))
            MoltenVKToggle(
                opts: $opts
            )
            .help(localizedCXPatcherString(forKey: "mkvToggleHelp"))
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
            FastMathToggle(
                opts: $opts
            )
            .help(localizedCXPatcherString(forKey: "fastMathToggleHelp"))
            MTLHUDToggle(
                opts: $opts
            )
            .help(localizedCXPatcherString(forKey: "hudToggleHelp"))
//            MsyncToggle(
//                opts: $opts
//            )
//            .help(localizedCXPatcherString(forKey: "msyncToggleHelp"))
        }.padding(20)
        .frame(width: 400.0)
        .fixedSize()
    }

}

struct Options_Previews: PreviewProvider {
    static var previews: some View {
        @State var opts = Opts()
        Options(opts: $opts)
    }
}
