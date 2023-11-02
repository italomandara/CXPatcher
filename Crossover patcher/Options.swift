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
            BottlesPathToggle(
                opts: $opts
            )
            IntegrateExternalsToggle(
                copyGptk: $opts.copyGptk
            )
            MoltenVKToggle(
                opts: $opts
            )
            DXVKToggle(
                opts: $opts
            )
            RemoveSignatureToggle(
                opts: $opts
            )
            Divider().padding(.vertical, 2)
            Text(localizedCXPatcherString(forKey: "Environment Globals")).padding(.top, 2)
            FastMathToggle(
                opts: $opts
            )
            MTLHUDToggle(
                opts: $opts
            )
            MsyncToggle(
                opts: $opts
            )
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
