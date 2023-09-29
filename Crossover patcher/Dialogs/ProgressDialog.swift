//
//  ProgressDialog.swift
//  CXPatcher
//
//  Created by Italo Mandara on 29/09/2023.
//

import Foundation
import SwiftUI

struct ProgressDialog: View {
    @Binding public var opts: Opts
    @Binding public var visible: Bool
    @State private var opacity: Double = 0.0
    private func action() -> Void {
        
        withAnimation(.easeIn) {
            opacity = 0.0
        }
        withAnimation() {
            visible = false
            opts.status = .unpatched
            opts.progress = 0.0
        }
    }
    private var isInProgress: Bool {
        let total = opts.getTotalProgress()
        return opts.progress < total
    }
    private var title: String {
        return isInProgress ? "Applying..." : "Done!"
    }
    var body: some View {
        ZStack {
            if(visible) {
//                Color(.white)
//                    .opacity(0.5)
                VStack{
                    Text(title)
                        .font(.title2)
                        .foregroundColor(.black)
                        .bold()
                    ProgressView(value: opts.progress, total: opts.getTotalProgress())
                    if(!isInProgress){
                        CustomButton(title: "OK", action: action, color: .red)
                    }
                }.padding(20)
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 20)
                .padding()
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn) {
                        opacity = 1.0
                    }
                }
            }
        }
    }
}

//struct ProgressDialog_Previews: PreviewProvider {
//    static var previews: some View {
//        ProgressDialog(opts: Opts(progress: 30.0))
//    }
//}

