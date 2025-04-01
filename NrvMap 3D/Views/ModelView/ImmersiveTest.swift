//
//  ImmersiveTest.swift
//  NrvMap 3D
//
//  Created by Ian So on 1/4/2025.
//

import RealityKit
import SwiftUI

struct SpaceControl: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @State private var isSpaceHidden: Bool = true
    var body: some View {
        Button(isSpaceHidden ? "View Outer Space" : "Exit the solar system") {
            Task {
                if isSpaceHidden {
                    await openImmersiveSpace(id: "test")
                    
                } else {
                    await dismissImmersiveSpace()
                    isSpaceHidden = true
                }
            }
        }
    }
}
