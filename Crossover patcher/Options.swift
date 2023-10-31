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
            if(ENABLE_SKIP_VERSION_CHECK_TOGGLE) {
                Divider()
                SkipVersionCheckToggle(skipVersionCheck: $opts.skipVersionCheck)
            }
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
