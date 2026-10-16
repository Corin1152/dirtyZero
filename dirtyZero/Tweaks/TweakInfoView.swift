//
//  TweakInfoView.swift
//  dirtyZero
//
//  Created by lunginspector on 4/17/26.
//

import SwiftUI
import PartyUI

struct TweakInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isTweakSupported: Bool
    
    var tweak: ZeroTweak
    var tweakType: SectionType
    
    let version = doubleSystemVersion()
    
    init(tweak: ZeroTweak, tweakType: SectionType, isTweakSupported: Bool = false) {
        self.tweak = tweak
        self.tweakType = tweakType
        if version >= tweak.minSupportedVersion && version <= tweak.maxSupportedVersion {
            self.isTweakSupported = true
        } else {
            self.isTweakSupported = false
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: tweak.icon)
                            // Text(String) 走 verbatim 语义，不会自动查表，需显式本地化
                            Text(tweak.name.localized)
                        }
                        
                        if tweakType == .custom {
                            InfoBadge(text: "Custom".localized, icon: "paintbrush", color: .purple)
                        } else if tweakType == .risky {
                            InfoBadge(text: "Risky".localized, icon: "exclamationmark.triangle", color: .red)
                        } else {
                            HStack {
                                InfoBadge(
                                    text: (isTweakSupported ? "Supported" : "Unsupported").localized,
                                    icon: isTweakSupported ? "checkmark.seal" : "xmark.seal",
                                    color: isTweakSupported ? .green : .red
                                )
                                
                                InfoBadge(text: tweak.maxSupportedVersion.description, icon: "arrow.up")
                                InfoBadge(text: tweak.minSupportedVersion.description, icon: "arrow.down")
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .modifier(SectionPlatter())
                    .listRowSeparator(.hidden)
                    .listRowInsets(.sectionInsets)
                } header: {
                    HeaderLabel(text: "Tweak Info".localized, icon: "info.circle")
                }
                
                Section {
                    ForEach(tweak.paths, id: \.self) { path in
                        Text(path)
                            .font(.system(.footnote, design: .monospaced))
                            .modifier(SectionPlatter())
                            .contextMenu {
                                Button {
                                    UIPasteboard.general.string = path
                                } label: {
                                    Label("Copy Path", systemImage: "doc.on.doc")
                                }
                            }
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(.sectionInsets)
                } header: {
                    HeaderLabel(text: "Target Paths".localized, icon: "character.cursor.ibeam")
                }
            }
            .listStyle(.plain)
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    // iOS 19+ 显示 xmark 图标，iOS 18 及以下显示文字
                    CloseSheetLabel("Done".localized)
                }
            }
        }
    }
}

#Preview {
    TweakInfoView(tweak: ZeroTweak(name: "Hide Dock Background", icon: "dock.rectangle", minSupportedVersion: 16.0, maxSupportedVersion: 18.3, paths: ["/System/Library/PrivateFrameworks/CoreMaterial.framework/dockDark.materialrecipe", "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockLight.materialrecipe"]), tweakType: .normal)
}
