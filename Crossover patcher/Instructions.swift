//
//  DisclaimerView.swift
//  Crossover patcher
//
//  Created by Italo Mandara on 03/04/2023.
//
import SwiftUI

struct Instructions: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        VStack(alignment: .center) {
            Image("Logo")
                .resizable(resizingMode: .stretch)
                .frame(width: 60.0, height: 60.0)
            Text(localizedCXPatcherString(forKey: "CrossOverPatcher"))
                .font(.title)
                .padding(.top, 1.0)
            Text(localizedCXPatcherString(forKey: "InstructionsAskWhatDo"))
                .font(.title2)
                .padding(.top, 30.0)
            Text(localizedCXPatcherString(forKey: "InstructionsFunctionDescription"))
                .padding(.top, 1.0)
                .multilineTextAlignment(.center)
            Text("\(localizedCXPatcherString(forKey: "Instructions")):")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.top, 20.0)
            Text(localizedCXPatcherString(forKey: "InstructionsText"))
                .multilineTextAlignment(.center)
                .padding(.top, 1.0)
            Text("https://codeweavers.com/account/downloads")
                .multilineTextAlignment(.center)
                .padding(.top, 1.0)
            Text(localizedCXPatcherString(forKey: "Credits"))
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.top, 20.0)
            Text(localizedCXPatcherString(forKey: "CreditsText"))
                .multilineTextAlignment(.center)
                .padding(.top, 1.0)
            //localization breaks hyperlinks. demons lurk
            Text("@gcenx (https://github.com/Gcenx)\n@nastys (https://github.com/nastys)")
                .multilineTextAlignment(.center)
                .padding(.top, 1.0)
        }.padding(40)
        .frame(width: 400.0)
        .fixedSize()
    }

}

struct Disclaimer_Previews: PreviewProvider {
    static var previews: some View {
        Instructions()
    }
}
