//
//  BottlePathToggle.swift
//  CXPatcher
//
//  Created by Italo Mandara on 11/07/2023.
//

import Foundation
import SwiftUI

struct BottlesPathToggle: View {
    @Binding var opts: Opts
    @State var isEditable = false
    var customColor: Color? {
        return (opts.cxbottlesPath != DEFAULT_CX_BOTTLES_PATH) ? Color.green : nil
    }
    var body: some View {
        Toggle(isOn: $opts.overrideBottlePath) {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    if(isEditable) {
                        TextField("",
                                  text: $opts.cxbottlesPath
                        )
                    } else {
                        Image(systemName: "waterbottle")
                        Text(localizedCXPatcherString(forKey: "bottlesPathToggle"))
                        Spacer()
                        Button() {
                            let panel = NSOpenPanel()
                            panel.allowsMultipleSelection = false
                            panel.canChooseDirectories = true
                            panel.canChooseFiles = false
                            if panel.runModal() == .OK {
                                opts.cxbottlesPath = panel.url?.path ?? DEFAULT_CX_BOTTLES_PATH
                            }
                        } label: {
                            Image(systemName: "gear").foregroundColor(customColor)
                        }
                        .buttonStyle(.plain)
                        .help(opts.cxbottlesPath)
                        
                    }
                }
            }
        }
        .padding(.vertical, 6.0)
        .toggleStyle(.switch)
        .controlSize(/*@START_MENU_TOKEN@*/.mini/*@END_MENU_TOKEN@*/)
        .disabled(isVentura)
    }
}

struct BottlesPathToggle_Previews: PreviewProvider {
    static var previews: some View {
        @State var opts = Opts()
        BottlesPathToggle(opts: $opts)
    }
}
