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
    @Binding public var total: Int32
    private func action() -> Void {
        visible = false
        opts.status = .unpatched
        opts.progress = 0.0
        console.clear()
    }
    private var computedValue: Float {
        return opts.progress / Float(total) * 100
    }
    var body: some View {
        ZStack {
            if(visible) {
                VStack{
                    if(!opts.busy){
                        CustomButton(title: localizedCXPatcherString(forKey: "continue"), action: action, color: .green)
                    } else {
//                        ProgressView(value: computedValue).accentColor(.gray)
                    }
                }.padding(.horizontal, 30)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct ProgressDialog_Previews: PreviewProvider {
    static var previews: some View {
        @State var opts = Opts(progress: 30.0)
        @State var visible = true
        @State var total: Int32 = 300
        ProgressDialog(opts: $opts, visible: $visible, total: $total)
    }
}

