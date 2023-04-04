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
            Text("Crossover Patcher")
                .font(.title)
                .padding(.top, 1.0)
            Text("What does it do?")
                .font(.title2)
                .padding(.top, 30.0)
            Text("This patcher will upgrade your crossover app with the latest dxvk and moltenvk patched for improved compatibility, and fix the current issue with the latest Ventura update")
                .padding(.top, 1.0)
                .multilineTextAlignment(.center)
            Text("Instructions:")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.top, 20.0)
            Text("You need to have an unmodified version of Crossover, you can download it at: https://www.codeweavers.com/account/downloads, please make sure the app has been registered or ran at least once, to make sure the latest dxvk is activated properly You may need to switch off dxvk and on again, if you don't you will need to re-download it. If the patcher renders the app unusable you can download it again from the website, it doesn't do any permanent modifications to any bottle")
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
