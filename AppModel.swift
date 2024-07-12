//
//  AppModel.swift
//  RobotCleanerSample
//
//  Created by Koichi Kishimoto on 2024/07/06.
//

import SwiftUI

@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"
    let contentViewID = "Content"
    let robotCleanerDustBoxID = "RobotCleanerDustBox"
    let robotCleanerDustBoxEntityName = "RobotCleanerDustBox"
    let robotCleanerPartsID = "RobotCleanerParts"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
}
