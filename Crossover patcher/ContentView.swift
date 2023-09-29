//
//  ContentView.swift
//  Crossover patcher
//
//  Created by Italo Mandara on 31/03/2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openWindow) var openWindow
    @State private var showDisclaimer = true
    @State public var status: Status = .unpatched
//    @State public var externalUrl: URL? = nil
    @State public var skipVersionCheck: Bool = false
    @State public var repatch: Bool = false
    @State private var integrateExternals: Bool = false
    @State private var overrideBottlePath: Bool = true
    @State public var opts: Opts
    
//    var shouldshowAppSelector: Bool {
//        if(integrateExternals) {
//            return externalUrl != nil
//        }
//        return true
//    }
    
    var body: some View {
        VStack(alignment: .center) {
            Logo()
            if(showDisclaimer) {
                Disclaimer(showDisclaimer: $showDisclaimer)
            } else {
                Button() {
                    openWindow(id: "instructions")
                } label: {
                    Image(systemName: "info.circle.fill")
                    Text(localizedCXPatcherString(forKey: "InstructionsButtonText"))
                }
                .padding(.bottom, 15.0)
                .buttonStyle(.borderedProminent)
//                if(shouldshowAppSelector) {
                    AppSelector(
//                        externalUrl: $externalUrl,
                        opts: $opts
                    )
//                } else {
//                    ExternalResourcesSelector(externalUrl: $externalUrl)
//                }
                VStack(alignment: .center) {
                    Divider()
//                    IntegrateExternalsToggle(
//                        integrateExternals: $integrateExternals,
//                        externalUrl: $externalUrl
//                    )
                    BottlesPathToggle(
                        overrideBottlePath: $opts.overrideBottlePath
                    )
                    Divider()
                    IntegrateExternalsToggle(
                        copyGptk: $opts.copyGptk
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
