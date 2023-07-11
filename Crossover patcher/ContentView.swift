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
    @State public var inputText: String = ""
    @State private var valid: Bool = false
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
            Text(localizedCXPatcherString(forKey: "CXPatcherName"))
                .font(.title)
                .padding(.vertical, 1.0)
            
            if(showDisclaimer) {
                Disclaimer()
                Text(localizedCXPatcherString(forKey:"confirmation"))
                    .padding(.vertical, 20)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                
                TextField("",
                    text: $inputText
                )
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
            } else {
                Button() {
                    openWindow(id: "instructions")
                } label: {
                    Image(systemName: "info.circle.fill")
                    Text(localizedCXPatcherString(forKey: "InstructionsButtonText"))
                }
                .padding(.bottom, 15.0)
                .buttonStyle(.borderedProminent)
                if(shouldshowAppSelector) {
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(getColorBy(status: status), style: StrokeStyle(lineWidth: 6, dash: [11.7]))
                        .foregroundColor(Color.black.opacity(0.5))
                        .frame(width: 340, height: 300)
                        .overlay(
                            VStack() {
                                Image(systemName: getIconBy(status: status)).foregroundColor(getColorBy(status: status)).font(.system(size: 60))
                                Text(getTextBy(status: status))
                                    .foregroundColor(getColorBy(status: status))
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                .padding(20.0)
                                
                            }
                        )
                        .contentShape(RoundedRectangle(cornerRadius: 25))
                        .onTapGesture {
                            if let url = openAppSelectorPanel() {
                                restoreAndPatch(repatch: repatch, url: url, status: &status, externalUrl: externalUrl, skipVersionCheck: skipVersionCheck)
                            }
                        }
                        .onDrop(of: [.fileURL], delegate: FileDropDelegate(externalUrl: $externalUrl, status: $status, skipVersionCheck: $skipVersionCheck, repatch: $repatch))
                    if(externalUrl != nil) {
                        HStack(alignment: .center) {
                            Image(systemName: "externaldrive.fill.badge.checkmark")
                            Text("External: \(externalUrl!.path)")
                        }
                        .padding(.top, 5.0)
                    }
                    Text(localizedCXPatcherString(forKey: "MediaFoundation"))
                        .padding(.top, 6.0)
                        .frame(alignment: .center)
                    Link(localizedCXPatcherString(forKey: "DownloadGStreamer"), destination: URL(string: "https://gstreamer.freedesktop.org/data/pkg/osx/1.22.4/gstreamer-1.0-1.22.4-universal.pkg")!)
                        .padding(.top, 6.0)
                        .buttonStyle(.borderedProminent)
                    
                    if(isGStreamerInstalled()) {
                        HStack(alignment: .center) {
                            Image(systemName: "checkmark.seal.fill").foregroundColor(.green)
                            Text(localizedCXPatcherString(forKey: "GStreamerInstalled"))
                        }
                        .padding(.top, 6.0)
                    }
                } else {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(Color.white.opacity(0.5))
                        .frame(width: 340, height: 200)
                        .overlay(
                            VStack(alignment: .center) {
                                Text(localizedCXPatcherString(forKey: "ExternalResourcesLabel"))
                                    .font(.title2)
                                Text(localizedCXPatcherString(forKey: "ExternalResourcesLocateText"))
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
                            Image(systemName: "wand.and.stars")
                            Text(localizedCXPatcherString(forKey: "ExternalResourcesToggle"))
                            Spacer()
                        }
                    }
                    .padding(.vertical, 6.0)
                    .toggleStyle(.switch)
                    .controlSize(/*@START_MENU_TOKEN@*/.mini/*@END_MENU_TOKEN@*/)
                    .disabled(isVentura)
                    .help(isVentura ? "GPTK is supported on Sonoma only" : "Enables installation of D3dMetal")
                    .onChange(of: integrateExternals) { value in
                        if (value == false) {
                            externalUrl = nil
                        }
                    }
                    if(ENABLE_SKIP_VERSION_CHECK_TOGGLE) {
                        Divider()
                        Toggle(isOn: $skipVersionCheck) {
                            HStack(alignment: .center) {
                                Image(systemName: "hazardsign.fill")
                                Text(localizedCXPatcherString(forKey: "ForcePatch"))
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
                                Image(systemName: "arrow.3.trianglepath")
                                Text(localizedCXPatcherString(forKey: "AllowRepatchUpgradeToggle"))
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
