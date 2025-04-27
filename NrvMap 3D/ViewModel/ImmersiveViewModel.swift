//
//  ImmersiveViewModel.swift
//  NrvMap 3D
//
//  Created by Ian So on 27/4/2025.
//

import SwiftUI
import RealityKit

class ImmersiveViewModel: ObservableObject {
    @Published var isMoving: Bool = false
    @Published var modelEntity: Entity?

    func playWalkingAnimation() {
        if let entity = modelEntity, !isMoving {
            entity.playAnimation(named: "default subtree animation", transitionDuration: 0.5, startsPaused: false)
            isMoving = true
        }
    }

    func stopAnimation() {
        if let entity = modelEntity {
            entity.stopAllAnimations()
            isMoving = false
        }
    }
}
