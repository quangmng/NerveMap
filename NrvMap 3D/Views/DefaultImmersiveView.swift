//
//  ImmersiveView.swift
//  NrvMap 3D
//
//  Created by Quang Minh Nguyen on 3/10/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct DefaultImmersiveView: View {

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)

                // Put skybox here.  See example in World project available at
                // https://developer.apple.com/
            }
        }
    }
}

#Preview(immersionStyle: .progressive) {
    DefaultImmersiveView()
        .environment(AppModel())
}
