//
//  Tools.swift
//  CXPatcher
//
//  Created by Italo Mandara on 17/05/2024.
//

import SwiftUI

struct Tools: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openWindow) var openWindow
    @State var cleard3dmCacheStatus: DeleteStatus = DeleteStatus.idle
    @State var clearSteamCachesStatus: DeleteStatus = DeleteStatus.idle
    @State var steamCacheFolderList: [URL] = []
    @State var scanningSteamFolders: Bool = false
    @State var deletedCachePath: String = ""
    
    var body: some View {
        VStack {
            if(ENABLE_CLEAR_D3DMETAL_CACHE || ENABLE_CLEAR_STEAM_CACHE) {
                HStack{
                    Text(localizedCXPatcherString(forKey: "d3dMetalCache"))
                    Spacer()
                    Button() {
                        cleard3dmCacheStatus = removeD3DMetalCaches()
                    } label: {
                        Image(systemName: "trash")
                        Text(localizedCXPatcherString(forKey: "clearD3dmetalCache"))
                    }
                    Button() {
                        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: darwinUserCacheDir()!.appendingPathComponent(D3DM_CACHE_FOLDER, isDirectory: true).path)
                    } label: {
                        Image(systemName: "folder")
                        Text(localizedCXPatcherString(forKey: "ShowD3dmetalCacheFolder"))
                    }
                }
                Divider()
                Button() {
                    scanningSteamFolders = true
                    steamCacheFolderList = getAllSteamShaderCacheDirectories()
                    scanningSteamFolders = false
                } label: {
                    Image(systemName: "magnifyingglass")
                    Text(localizedCXPatcherString(forKey: "findSteamCaches"))
                }.padding(.top, 20)
            }
            if(ENABLE_CLEAR_D3DMETAL_CACHE) {
                switch cleard3dmCacheStatus {
                case DeleteStatus.success:
                    Text(localizedCXPatcherString(forKey: "d3dmetalCacheDeleted"))
                case DeleteStatus.failed:
                    Text(localizedCXPatcherString(forKey: "d3dmetalCacheDeleteFailed"))
                default:
                    EmptyView()
                }
            }
            if(ENABLE_CLEAR_STEAM_CACHE) {
                if (scanningSteamFolders == true) {
                    Text(localizedCXPatcherString(forKey: "scanningSteamFolders"))
                }
                    List {
                        if(steamCacheFolderList.isEmpty) {
                            Text(localizedCXPatcherString(forKey: "clickFindSteamCaches"))
                        }
                        ForEach(steamCacheFolderList, id: \.self) { path in
                            HStack{
                                Text(shortenSteamCachePath(path.absoluteString))
                                Spacer()
                                Button() {
                                    deletedCachePath = shortenSteamCachePath(path.absoluteString)
                                    clearSteamCachesStatus = removeAllSteamCachesFrom(path: path.path)
                                } label: {
                                    Image(systemName: "trash")
                                }
                                Button() {
                                    NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: path.path)
                                } label: {
                                    Image(systemName: "folder")
                                }
                            }.buttonStyle(.borderless)
                        }
                    }.frame(minHeight: 300).cornerRadius(UIGlobals.radius.rawValue).padding(.top, 10)
                
                switch clearSteamCachesStatus {
                case DeleteStatus.success:
                    Text(localizedCXPatcherString(forKey: "steamCacheDeleted"))
                    Text(deletedCachePath)
                case DeleteStatus.failed:
                    Text(localizedCXPatcherString(forKey: "steamCacheDeleteFailed"))
                case DeleteStatus.progress:
                    Text(localizedCXPatcherString(forKey: "steamCacheDeleteInProgress"))
                default:
                    EmptyView()
                }
            }
        }.padding(20)
        .frame(width: 400.0)
        .fixedSize()
    }
}

struct Tools_Previews: PreviewProvider {
    static var previews: some View {
        Tools()
    }
}
