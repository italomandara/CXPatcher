//
//  Disclaimer.swift
//  Crossover patcher
//
//  Created by Italo Mandara on 04/04/2023.
//

import SwiftUI

struct Disclaimer: View {
    var body: some View {
        Text(localizedCXPatcherString(forKey: "DisclaimerPleaseNoteLabelText"))
            .font(.title2)
            .multilineTextAlignment(.center)
        Text(localizedCXPatcherString(forKey: "DisclaimerText"))
            .multilineTextAlignment(.center)
            .padding(10)
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(10)
        Spacer()
        //localization breaks hyperlinks. demons lurk
        Text("\(localizedCXPatcherString(forKey: "CWWebsite")) [CodeWeavers forums](https://www.codeweavers.com/support/forums/general/?t=27;msg=257865)")
            .multilineTextAlignment(.center)
            .padding(.top, 1.0)
    }
}
