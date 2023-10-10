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
                        Image(systemName: "gear")
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
