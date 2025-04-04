//
//  Model3D.swift
//  NrvMap 3D
//
//  Created by Ian So on 1/4/2025.
//

import Foundation
import SwiftUI
import RealityKit
import RealityKitContent

struct Model3DViewTest: View {
    
    @State var initialPosition: SIMD3<Float>? = nil
    @State var initialScale: SIMD3<Float>? = nil
    
    var translationGesture: some Gesture {
        /// The gesture to move an entity.
        DragGesture()
            .targetedToAnyEntity()
            .onChanged({ value in
                /// The entity that the drag gesture targets.
                let rootEntity = value.entity

                // Set `initialPosition` to the position of the entity if it is `nil`.
                if initialPosition == nil {
                    initialPosition = rootEntity.position
                }

                /// The movement that converts a global world space to the scene world space of the entity.
                let movement = value.convert(value.translation3D, from: .global, to: .scene)

                // Apply the entity position to match the drag gesture,
                // and set the movement to stay at the ground level.
                rootEntity.position = (initialPosition ?? .zero) + movement.grounded
            })
            .onEnded({ _ in
                // Reset the `initialPosition` back to `nil` when the gesture ends.
                initialPosition = nil
            })
    }
    
    /// The gesture checks whether there is a root component and adjusts the scale of the entity.
    var scaleGesture: some Gesture {
        /// The gesture to scale the entity with two hands.
        MagnifyGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                /// The entity that the magnify gesture targets.
                let rootEntity = value.entity

                // Set the `initialScale` to the scale of the entity if it is `nil`.
                if initialScale == nil {
                    initialScale = rootEntity.scale
                }

                /// The rate that the model will scale by.
                let scaleRate: Float = 1.0

                // Scale the entity up smoothly by the relative magnification on the gesture.
                rootEntity.scale = (initialScale ?? .init(repeating: scaleRate)) * Float(value.gestureValue.magnification)
            }
            .onEnded { _ in
                // Reset the `initialScale` back to `nil` when the gesture ends.
                initialScale = nil
            }
    }
    
    var body: some View {
        
        RealityView { content in
            let fileName: String = "FemaleDModel"
            guard let femaleModel = try? await ModelEntity(named: fileName) else {
                assertionFailure("Failed to load model: \(fileName)")
                return
            }
            let bounds = femaleModel.visualBounds(relativeTo: nil)
            let carWidth: Float = (femaleModel.model?.mesh.bounds.max.x)!
            let carHeight: Float = (femaleModel.model?.mesh.bounds.max.y)!
            let carDepth: Float = (femaleModel.model?.mesh.bounds.max.z)!
            let boxShape = ShapeResource.generateBox(
                width: carWidth,
                height: carHeight,
                depth: carDepth)

            // Add a box shape as a collision component.
            femaleModel.components.set(CollisionComponent(shapes: [boxShape]))
            
            // Enable inputs from the hand gestures.
            femaleModel.components.set(InputTargetComponent())
            
            // Set the spawn position of the entity on the ground.
            femaleModel.position.y -= bounds.min.y
            
            // Set the spawn position along the z-axis, with the edge of the visual bound.
            femaleModel.position.z += bounds.min.z

            // Set the spawn position along the x-axis, with the edge of the visual bound.
            femaleModel.position.x += bounds.min.x

            femaleModel.scale /= 1.5

            // Add the car model to the `RealityView`.
            content.add(femaleModel)
        }
        // Enable the `translationGesture` to the `RealityView`.
        .gesture(translationGesture)
        // Enable the `scaleGesture` to the `RealityView`.
        .gesture(scaleGesture)
    }
}
#Preview{
    Model3DViewTest()
}
