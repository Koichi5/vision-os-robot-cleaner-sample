//
//  RobotCleanerDustBox.swift
//  RobotCleanerSample
//
//  Created by Koichi Kishimoto on 2024/07/07.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct RobotCleanerDustBox: View {
    @Environment(\.realityKitScene) var scene
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @State private var currentIndex = 1
    let rkcb = realityKitContentBundle
    let rknt = "RealityKit.NotificationTrigger"
    
    fileprivate func notify(scene: RealityKit.Scene, animationName: String) {
        let notification = Notification(
            name: .init(rknt),
            userInfo: ["\(rknt).Scene" : scene,"\(rknt).Identifier" : animationName])
        NotificationCenter.default.post(notification)
    }
    // Reality Composer Pro で定義しているアニメーションの命名が1番から始まるため
    let descriptions: [String] = ["", "", "上部のフタを開ける", "フィルターがついた状態で\nダストボックスを取り出す", "ゴミ箱を用意して\nダストボックス内のゴミを取り出してください"]
    
    var body: some View {
        RealityView { content, attachments in
            if let robotCleanerEntity = try? await Entity(named: "DustBox", in: realityKitContentBundle) {
                if let scene = robotCleanerEntity.scene {
                    NotificationCenter.default.post(
                        name: Notification.Name("RealityKit.NotificationTrigger"),
                        object: nil,
                        userInfo: [
                            "RealityKit.NotificationTrigger.Scene": scene,
                            "RealityKit.NotificationTrigger.Identifier": "Step1"
                        ])
                }
                robotCleanerEntity.scale = SIMD3<Float>(1.5, 1.5, 1.5)
                robotCleanerEntity.position = robotCleanerEntity.position(relativeTo: robotCleanerEntity) + SIMD3<Float>(0, -0.2, 0.1)
                content.add(robotCleanerEntity)
                if let sceneAttachment = attachments.entity(for: "RobotCleanerDustBox") {
                    sceneAttachment.position = sceneAttachment.position(relativeTo: robotCleanerEntity) + SIMD3<Float>(0, -0.5, 0.3)
                    
                    content.add(sceneAttachment)
                }
            }
        } attachments: {
            Attachment(id: "RobotCleanerDustBox") {
                if currentIndex < descriptions.count {
                    VStack {
                        Text(descriptions[currentIndex])
                        Spacer()
                            .frame(height: 30)
                        if currentIndex == 4 {
                            Button("完了") {
                                currentIndex += 1
                                openWindow(id: "Content")
                            }
                        } else {
                            Button("Step\(currentIndex)へ") {
                                if let scene { notify(scene: scene, animationName: "Step\(currentIndex)") }
                                currentIndex += 1
                            }
                        }
                        Spacer()
                            .frame(height: 30)
                        Button {
                            openWindow(id: "Content")
                            dismissWindow(id: "RobotCleanerDustBox")
                        } label: {
                            HStack {
                                Image(systemName: "xmark")
                                Text("閉じる")
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            dismissWindow(id: "Content")
        }
    }
}
