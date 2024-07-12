//
//  ContentView.swift
//  RobotCleanerSample
//
//  Created by Koichi Kishimoto on 2024/07/06.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var appModel = AppModel()
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    var body: some View {
        NavigationStack {
            List {
                Button {
                    openWindow(id: appModel.robotCleanerDustBoxID)
                } label: {
                    HStack {
                        Image(systemName: "paintbrush")
                        Spacer()
                        Text("手入れの方法")
                    }
                }
                .padding()
                
                Button {
                    openWindow(id: appModel.robotCleanerPartsID)
                } label: {
                    HStack {
                        Image(systemName: "hammer")
                        Spacer()
                        Text("パーツの詳細")
                    }
                }
                .padding()
            }
            .padding()
            .onAppear {
                // ContentView を開いた際には命令的に他のすべての window を dismiss する
                dismissWindow(id: appModel.robotCleanerDustBoxID)
                dismissWindow(id: appModel.robotCleanerPartsID)
            }
            .navigationTitle("ガイド")
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
