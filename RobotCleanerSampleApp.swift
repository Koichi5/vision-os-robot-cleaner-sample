//
//  RobotCleanerSampleApp.swift
//  RobotCleanerSample
//
//  Created by Koichi Kishimoto on 2024/07/06.
//

import SwiftUI

@main
struct RobotCleanerSampleApp: App {
    @State private var appModel = AppModel()
    var body: some Scene {
        WindowGroup(id: appModel.contentViewID) {
            ContentView()
                .environment(appModel)
        }
        .windowResizability(.contentSize)
        .defaultSize(CGSize(width: 400, height: 330))
        
        WindowGroup(id: appModel.robotCleanerDustBoxID) {
            RobotCleanerDustBox()
        }
        .windowStyle(.volumetric)
        
        WindowGroup(id: appModel.robotCleanerPartsID) {
            RobotCleanerParts()
                .frame(width: 1200, height: 1500)
        }
        .windowStyle(.volumetric)

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.full), in: .full)
    }
}
