//
//  Disclaimer.swift
//  Crossover patcher
//
//  Created by Italo Mandara on 04/04/2023.
//

import SwiftUI

struct Disclaimer: View {
    var body: some View {
        Text("Please note:")
            .font(.title2)
            .multilineTextAlignment(.center)
        Text("This is an unofficial patcher for Crossover and codeweavers has nothing to do with this app, and although has tested, this software may render the app unusable or unstable, USE AT YOUR OWN RISK, this also will void any official support from Codeweavers if you have any issues after your app has been patched you can download a new copy of Crossover.")
            .multilineTextAlignment(.center)
            .padding(.top, 1.0)
        Text("for more info: https://www.codeweavers.com/support/forums/general/?t=27;msg=257865")
            .multilineTextAlignment(.center)
            .padding(.top, 1.0)
    }
}
