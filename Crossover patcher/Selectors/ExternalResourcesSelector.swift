//
//  ExternalResourcesSelector.swift
//  CXPatcher
//
//  Created by Italo Mandara on 11/07/2023.
//

import Foundation
import SwiftUI

struct ExternalResourcesSelector: View {
    @Binding var externalUrl: URL?
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .foregroundColor(Color.white.opacity(0.5))
            .frame(width: 340, height: 200)
            .overlay(
                VStack(alignment: .center) {
                    Text(localizedCXPatcherString(forKey: "ExternalResourcesLabel"))
                        .font(.title2)
                    Text(localizedCXPatcherString(forKey: "ExternalResourcesLocateText"))
                        .padding(.vertical, 1.0)
                        .multilineTextAlignment(.center)
                    ExternalResButtonDialog(externalUrl: $externalUrl)
                        .padding(.top, 6.0).controlSize(.large)
                }
            )
    }
}
