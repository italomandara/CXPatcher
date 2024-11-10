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
        RoundedRectangle(cornerRadius: 25)
            .foregroundColor(Color.white.opacity(0.5))
            .frame(width: 340, height: 200)
            .overlay(
                VStack(alignment: .center) {
                    Text(localizedCXPatcherString(forKey: "XtLibsLabel"))
                        .font(.title2)
                    Text(localizedCXPatcherString(forKey: "XtLibsLocateText"))
                        .padding(.vertical, 1.0)
                        .multilineTextAlignment(.center)
                    XtLibsUrlButtonDialog(XtLibsUrl: $XtLibsUrl)
                        .padding(.top, 6.0).controlSize(.large)
                }
            )
    }
}
