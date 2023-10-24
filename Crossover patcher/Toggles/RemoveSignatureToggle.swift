//
//  RemoveSignatureToggle.swift
//  CXPatcher
//
//  Created by Italo Mandara on 24/10/2023.
//

import Foundation
import SwiftUI

struct RemoveSignatureToggle: View {
    @Binding var opts: Opts
    
    var body: some View {
        Toggle(isOn: $opts.removeSignaure) {
            HStack(alignment: .center) {
                Image(systemName: "signature")
                Text(localizedCXPatcherString(forKey: "Remove signature"))
                Spacer()
            }
        }
        .padding(.vertical, 6.0)
        .toggleStyle(.switch)
        .controlSize(/*@START_MENU_TOKEN@*/.mini/*@END_MENU_TOKEN@*/)
    }
}
