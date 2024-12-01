//
//  ExternalResourcesSelector.swift
//  CXPatcher
//
//  Created by Italo Mandara on 11/07/2023.
//

import Foundation
import SwiftUI

struct XtLibsUrlSelector: View {
    @Binding var XtLibsUrl: URL?
    
    var body: some View {
        Text(localizedCXPatcherString(forKey: "XtLibsLabel"))
            .font(.title2)
        Text(localizedCXPatcherString(forKey: "XtLibsDisclaimerText"))
            .padding(.vertical, 1.0)
            .multilineTextAlignment(.center)
        Text(localizedCXPatcherString(forKey: "XtLibsLocateText"))
            .padding(.vertical, 1.0)
            .multilineTextAlignment(.center)
        XtLibsUrlButtonDialog(XtLibsUrl: $XtLibsUrl)
            .padding(.top, 6.0).controlSize(.large)
    }
}
