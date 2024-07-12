//
//  RobotCleanerParts.swift
//  RobotCleanerSample
//
//  Created by Koichi Kishimoto on 2024/07/07.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct RobotCleanerParts: View {
    @Environment(\.realityKitScene) var scene
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    @State private var showDetail = false
    @State private var appModel = AppModel()
    
    let rkcb = realityKitContentBundle
    let rknt = "RealityKit.NotificationTrigger"
    let partsEntityNameList = [
        "back_left_wheel",
        "back_right_wheel",
        "body",
        "brush",
        "bumper",
        "dust_box",
        "filter",
        "front_wheel",
        "lib",
        "main_brush"
    ]
    
    fileprivate func notify(scene: RealityKit.Scene, animationName: String) {
        let notification = Notification(
            name: .init(rknt),
            userInfo: [
                "\(rknt).Scene" : scene,
                "\(rknt).Identifier" : animationName
            ]
        )
        NotificationCenter.default.post(notification)
    }
    
    var body: some View {
        RealityView { content, attachments in
            if let robotCleanerEntity = try? await Entity(named: "Parts", in: realityKitContentBundle) {
                if let scene = robotCleanerEntity.scene {
                    NotificationCenter.default.post(
                        name: Notification.Name("RealityKit.NotificationTrigger"),
                        object: nil,
                        userInfo: [
                            "RealityKit.NotificationTrigger.Scene": scene,
                            "RealityKit.NotificationTrigger.Identifier": "Step1"
                        ])
                }
                robotCleanerEntity.position = robotCleanerEntity.position(relativeTo: robotCleanerEntity) + SIMD3<Float>(0, -0.05, 0.1)
                content.add(robotCleanerEntity)
                // パーツごとのアタッチメントを追加したい
                // for partEntityName in partsEntityNameList {
                //   let entity = robotCleanerEntity.scene?.findEntity(named: partEntityName)
                //   if let attachment = attachments.entity(for: partEntityName) {
                //     attachment.position = attachment.position(relativeTo: entity)
                //     content.add(attachment)
                //    }
                // }
                if let sceneAttachment = attachments.entity(for: appModel.robotCleanerDustBoxEntityName) {
                    sceneAttachment.position = sceneAttachment.position(relativeTo: robotCleanerEntity) + SIMD3<Float>(0, -0.5, 0.3)
                    
                    content.add(sceneAttachment)
                }
            }
        } attachments: {
            Attachment(id: appModel.robotCleanerDustBoxEntityName) {
                VStack {
                    Toggle(isOn: $showDetail) {
                        Text("詳細").font(.title)
                    }.onChange(of: showDetail) {
                        if(showDetail) {
                            if let scene { notify(scene: scene, animationName: "Apart") }
                        } else {
                            if let scene { notify(scene: scene, animationName: "Together") }
                        }
                    }
                    .frame(width: 200)
                    Spacer()
                        .frame(height: 30)
                    Button {
                        openWindow(id: appModel.contentViewID)
                    } label: {
                        HStack {
                            Image(systemName: "xmark")
                            Text("閉じる")
                        }
                    }
                }
            }
            // パーツごとのアタッチメントを追加したい
            // ForEach(0..<partsEntityNameList.count, id: \.self) { index in
            //   Attachment(id: partsEntityNameList[index]) {
            //     Text(partsEntityNameList[index])
            //   }
            // }
        }
        .onAppear {
            dismissWindow(id: appModel.contentViewID)
        }
        
    }
}
