//
//  ContentView.swift
//  Crossover patcher
//
//  Created by Italo Mandara on 31/03/2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openWindow) var openWindow
    @Binding public var opts: Opts
    
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
                    if(ENABLE_SKIP_VERSION_CHECK_TOGGLE) {
                        Divider()
                        SkipVersionCheckToggle(skipVersionCheck: $opts.skipVersionCheck)
                    }
                    if(ENABLE_SKIP_VERSION_CHECK_TOGGLE) {
                        Divider()
                        SkipVersionCheckToggle(skipVersionCheck: $opts.skipVersionCheck)
                    }
                    if(ENABLE_REPATCH_TOGGLE) {
                        Divider()
                        RepatchToggle(repatch: $opts.repatch)
                        Divider()
                    }
                    VStack {
                        if(ENABLE_CLEAR_D3DMETAL_CACHE) {
                            CustomButton(title: localizedCXPatcherString(forKey: "Clear d3dmetal cache"), action: {
                                // do nothing
                            }, color: .gray)
                        }
                        if(ENABLE_CLEAR_D3DMETAL_CACHE) {
                            CustomButton(title: localizedCXPatcherString(forKey: "Clear steam shader cache"), action: {
                                // do nothing
                            }, color: .gray)
                        }
                        if(ENABLE_FIX_CX_CODESIGN) {
                            CustomButton(title: localizedCXPatcherString(forKey: "Fix CX codesign"), action: {
                                // do nothing
                            }, color: .gray)
                        }
                    }
                    HStack {
                        if(ENABLE_RESTORE) {
                            RestoreButtonDialog(opts: opts)
                                .padding(.top, 6.0)
                        }
                        OptionsButton()
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
        @State var opts = Opts(showDisclaimer: false)
        ContentView(opts: $opts)
    }
}
