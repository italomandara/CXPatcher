//
//  CustomButton.swift
//  CXPatcher
//
//  Created by Italo Mandara on 29/09/2023.
//

import Foundation
import SwiftUI

struct CustomButton: View {
    @State var title: String
    @State var action: () -> ()
    @State var color: Color
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    
            }
        }
        .buttonStyle(.plain)
        .fixedSize(horizontal: true, vertical: true)
            
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(title: "My Button", action: {}, color: .red)
    }
}
