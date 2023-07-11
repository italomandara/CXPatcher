//
//  Logo.swift
//  CXPatcher
//
//  Created by Italo Mandara on 11/07/2023.
//

import Foundation
import SwiftUI

struct Logo: View {
    var body: some View {
        Image("Logo")
            .resizable(resizingMode: .stretch)
            .frame(width: 80.0, height: 80.0)
        Text(localizedCXPatcherString(forKey: "CXPatcherName"))
            .font(.title)
        .padding(.vertical, 1.0)
    }
}
