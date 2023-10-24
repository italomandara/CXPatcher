//
//  ContentView.swift
//  Crossover patcher
//
//  Created by Italo Mandara on 31/03/2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openWindow) var openWindow
    @State public var opts: Opts
    
    var body: some View {
        VStack(alignment: .center) {
            Logo()
            if(opts.showDisclaimer) {
                Disclaimer(showDisclaimer: $opts.showDisclaimer)
            } else {
                Button() {
                    openWindow(id: "instructions")
                } label: {
                    Image(systemName: "info.circle.fill")
                    Text(localizedCXPatcherString(forKey: "InstructionsButtonText"))
                }
                .padding(.bottom, 15.0)
                .buttonStyle(.borderedProminent)

                    AppSelector(
                        opts: $opts
                    )
                VStack(alignment: .center) {
                    Divider()
                    BottlesPathToggle(
                        opts: $opts
                    )
                    Divider()
                    IntegrateExternalsToggle(
                        copyGptk: $opts.copyGptk
                    )
                    Divider()
                    MoltenVKToggle(
                        opts: $opts
                    )
                    Divider()
                    DXVKToggle(
                        opts: $opts
                    )
                    Divider()
                    RemoveSignatureToggle(
                        opts: $opts
                    )
                    if(ENABLE_SKIP_VERSION_CHECK_TOGGLE) {
                        Divider()
                        SkipVersionCheckToggle(skipVersionCheck: $opts.skipVersionCheck)
                    }
                    if(ENABLE_REPATCH_TOGGLE) {
                        Divider()
                        RepatchToggle(repatch: $opts.repatch)
                        Divider()
                    }
                    if(ENABLE_RESTORE) {
                        RestoreButtonDialog(opts: opts)
                            .padding(.top, 6.0)
                    }
                }
                .padding(.top, 12.0)
            }
        }
        .padding(20)
        .frame(width: 400.0)
        .fixedSize()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(opts: Opts())
    }
}
