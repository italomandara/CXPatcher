//
//  ContentView.swift
//  Crossover patcher
//
//  Created by Italo Mandara on 31/03/2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openWindow) var openWindow
    @State private var showDisclaimer = true
    @State public var status: Status = .unpatched
    @State public var externalUrl: URL? = nil
    @State public var skipVersionCheck: Bool = false
    @State public var repatch: Bool = false
    @State private var integrateExternals:Bool = false
    var shouldshowAppSelector: Bool {
        if(integrateExternals) {
            return externalUrl != nil
        }
        return true
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Image("Logo")
                .resizable(resizingMode: .stretch)
                .frame(width: 80.0, height: 80.0)
            Text("Crossover Patcher")
                .font(.title)
                .padding(.vertical, 1.0)
            
            if(showDisclaimer) {
                Disclaimer()
                Button("Agree and proceed") {
                    showDisclaimer = false
                }.padding(.vertical, 20.0).buttonStyle(.borderedProminent)
            } else {
                Button("Instructions") {
                    openWindow(id: "instructions")
                }
                .padding(.bottom, 15.0)
                .buttonStyle(.borderedProminent)
                if(shouldshowAppSelector) {
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(getColorBy(status: status), style: StrokeStyle(lineWidth: 6, dash: [11.7]))
                        .foregroundColor(Color.black.opacity(0.5))
                        .frame(width: 340, height: 300)
                        .overlay(                Text(getTextBy(status: status))
                            .foregroundColor(getColorBy(status: status))
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(20.0)
                        )
                        .contentShape(RoundedRectangle(cornerRadius: 25))
                        .onTapGesture {
                            if let url = openAppSelectorPanel() {
                                restoreAndPatch(repatch: repatch, url: url, status: &status, externalUrl: externalUrl, skipVersionCheck: skipVersionCheck)
                            }
                        }
                        .onDrop(of: [.fileURL], delegate: FileDropDelegate(externalUrl: $externalUrl, status: $status, skipVersionCheck: $skipVersionCheck, repatch: $repatch))
                } else {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(Color.white.opacity(0.5))
                        .frame(width: 340, height: 200)
                        .overlay(
                            VStack(alignment: .center) {
                                Text("External resources")
                                    .font(.title2)
                                Text("Please locate the\n\"external resources\" drive\nusing the button below")
                                    .padding(.vertical, 1.0)
                                    .multilineTextAlignment(.center)
                                ExternalResButtonDialog(externalUrl: $externalUrl)
                                    .padding(.top, 6.0).controlSize(.large)
                            }
                        )
                }
                VStack(alignment: .center) {
                    Divider()
                    Toggle(isOn: $integrateExternals) {
                        HStack(alignment: .center) {
                            Text("Integrate external resources")
                            Spacer()
                        }
                    }
                    .padding(.vertical, 6.0)
                    .toggleStyle(.switch)
                    .controlSize(/*@START_MENU_TOKEN@*/.mini/*@END_MENU_TOKEN@*/)
                    if(ENABLE_SKIP_VERSION_CHECK_TOGGLE) {
                        Divider()
                        Toggle(isOn: $skipVersionCheck) {
                            HStack(alignment: .center) {
                                Text("Force Patch")
                                Spacer()
                            }
                        }
                        .padding(.vertical, 6.0)
                        .toggleStyle(.switch)
                        .controlSize(/*@START_MENU_TOKEN@*/.mini/*@END_MENU_TOKEN@*/)
                    }
                    if(ENABLE_REPATCH_TOGGLE) {
                        Divider()
                        Toggle(isOn: $repatch) {
                            HStack(alignment: .center) {
                                Text("Allow repatch / upgrade")
                                Spacer()
                            }
                        }
                        .padding(.vertical, 6.0)
                        .toggleStyle(.switch)
                        .controlSize(/*@START_MENU_TOKEN@*/.mini/*@END_MENU_TOKEN@*/)
                        Divider()
                        
                    }
                    if(ENABLE_RESTORE) {
                        RestoreButtonDialog()
                            .padding(.top, 6.0)
                    }
                }
                .padding(.top, 12.0)
            }
        }
        .padding(20)
        .frame(width: 400.0)
        .fixedSize()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
