//
//  Disclaimer.swift
//  Crossover patcher
//
//  Created by Italo Mandara on 04/04/2023.
//

import SwiftUI

struct Disclaimer: View {
    @State public var inputText: String = ""
    @State private var valid: Bool = false
    @Binding var showDisclaimer: Bool
    
    var body: some View {
        Text(localizedCXPatcherString(forKey: "DisclaimerPleaseNoteLabelText"))
            .font(.title2)
            .multilineTextAlignment(.center)
            .fontWeight(.bold)
            .foregroundColor(.red)
        Text(localizedCXPatcherString(forKey: "DisclaimerText"))
            .multilineTextAlignment(.center)
            .padding(10)
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(UIGlobals.radius.rawValue)
        Spacer()
        //localization breaks hyperlinks. demons lurk
        Text("\(localizedCXPatcherString(forKey: "CWWebsite")) [CodeWeavers forums](https://www.codeweavers.com/support/forums/general/?t=27;msg=257865)")
            .multilineTextAlignment(.center)
            .padding(.top, 1.0)
        if(SKIP_DISCLAIMER_CHECK) {
            Button() {
                showDisclaimer = false
            } label: {
                Image(systemName: "exclamationmark.triangle.fill")
                Text(localizedCXPatcherString(forKey: "AgreeAndProceedButtonText"))
            }
            .padding(.vertical, 20.0)
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .controlSize(.large)
        } else {
            Text(localizedCXPatcherString(forKey:"confirmation"))
                .padding(.vertical, 20)
                .fontWeight(.bold)
                .foregroundColor(.red)
            
            TextField("",
                      text: $inputText
            )
            .onSubmit {
                if (valid) {
                    showDisclaimer = false
                }
            }
            .onChange(of: inputText) { newValue in
                valid = validate(input: newValue)
            }
            .disableAutocorrection(true)
            Button() {
                showDisclaimer = false
            } label: {
                Image(systemName: "exclamationmark.triangle.fill")
                if(valid) {
                    Text(localizedCXPatcherString(forKey: "AgreeAndProceedButtonText"))
                } else {
                    Text("\(localizedCXPatcherString(forKey: "waitFor"))")
                }
            }
            .padding(.vertical, 20.0)
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .controlSize(.large)
            .disabled(!valid)
        }
    }
}
