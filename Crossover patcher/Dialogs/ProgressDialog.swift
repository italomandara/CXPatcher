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
    @Binding public var total: Float16
    private func action() -> Void {
        withAnimation(.easeIn) {
            opacity = 0.0
        }
        visible = false
        opts.status = .unpatched
        opts.progress = 0.0
    }
    var body: some View {
        ZStack {
            if(visible) {
                VStack{
                    if(!opts.busy){
                        CustomButton(title: "Continue", action: action, color: .green)
                    }
                    ProgressView(value: opts.progress, total: total).accentColor(.gray)
                }.padding(.horizontal, 30)
                .fixedSize(horizontal: false, vertical: true)
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

struct ProgressDialog_Previews: PreviewProvider {
    static var previews: some View {
        @State var opts = Opts(progress: 30.0)
        @State var visible = true
        @State var total: Float16 = 300.0
        ProgressDialog(opts: $opts, visible: $visible, total: $total)
    }
}

