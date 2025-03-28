//
//  ModelView.swift
//  NrvMap 3D
//
//  Created by Ian So on 25/3/2025.
//

import SwiftUI
import RealityKit

struct FemaleModelView: View {
    @State private var modelEntity: Entity? // Store reference to 3D model
    @State private var selectedEntity: Entity?
    @State private var originalTransform: Transform?
    
    @State private var currentScale: Float = 1.0  // Track zoom scale
    @State private var rotationAngle: Float = 0.0 // Track rotation angle
    @State private var lastDragValue: CGFloat = 0 // Store last drag position

    var body: some View {
        HStack {
            ZStack {
                RealityView { content in
                    do {
                        let entity = try await Entity.load(named: "FemaleDModel")
                        entity.scale = SIMD3<Float>(0.5, 0.5, 0.5)
                        entity.generateCollisionShapes(recursive: true) // Enable tap & drag
                        entity.position = SIMD3<Float>(0, -0.5, 0)
                        
                        enableInteraction(for: entity)
                        content.add(entity)
                        
                        modelEntity = entity
                        originalTransform = entity.transform // Save original position
                    } catch {
                        print("Failed to load model: \(error)")
                    }
                }
                // **Add Drag & Tap Gestures for Interaction**
                .gesture(
                    DragGesture()
                        .targetedToAnyEntity()
                        .onChanged { event in
                            if let entity = selectedEntity {
                                let delta = SIMD3<Float>(Float(event.translation.width) * 0.001, 0, Float(event.translation.height) * -0.001)
                                entity.transform.translation += delta
                            }
                        }
                        .onEnded { _ in print("Drag ended") }
                )
                .gesture(
                    TapGesture()
                        .targetedToAnyEntity()
                        .onEnded { event in
                            selectedEntity = event.entity
                            highlightEntity(event.entity)
                        }
                )
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            zoomModel(to: Float(value))
                        }
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            rotateModel(by: Float(value.translation.width - lastDragValue) * 0.2)
                            lastDragValue = value.translation.width
                        }
                        .onEnded { _ in lastDragValue = 0 }
                )

                // **Right-aligned Button Bar**
                HStack {
                    Spacer().frame(width: 600)
                    VStack {
                        Button {
                            resetModelPosition()
                        } label: {
                            Image(systemName: "house")
                        }
                        .frame(width: 50, height: 50)
                        .padding()

                        Button {
                            // Zoom functionality
                            zoomModel(to: 1.5)
                        } label: {
                            Image(systemName: "square.resize")
                        }
                        .frame(width: 50, height: 50)
                        .padding()

                        Button {
                            // Rotate model
                            rotateModel(by: 45.0)
                        } label: {
                            Image(systemName: "move.3d")
                        }
                        .frame(width: 50, height: 50)
                        .padding()

                        Button {
                            print("Favorite tapped")
                        } label: {
                            Image(systemName: "heart.text.clipboard")
                        }
                        .frame(width: 50, height: 50)
                        .padding()
                    }
                }
            }
        }
        .background(.clear)
    }

    // **Zoom Function**
    private func zoomModel(to scale: Float) {
        if scale > 0.5 && scale < 3.0 { // Limit zoom range
            currentScale = scale
            modelEntity?.scale = SIMD3(repeating: currentScale)
        }
    }

    // **Rotate Function**
    private func rotateModel(by degrees: Float) {
        if let entity = modelEntity {
            rotationAngle += degrees
            let radians = (rotationAngle * .pi) / 180 // Convert degrees to radians
            entity.transform.rotation = simd_quatf(angle: radians, axis: [0, 1, 0]) // Rotate on Y-axis
        }
    }

    // **Reset Model Position**
    private func resetModelPosition() {
        if let entity = modelEntity, let originalTransform {
            entity.transform = originalTransform
        }
    }
}
func enableInteraction(for entity: Entity) {
    entity.components.set(InputTargetComponent()) // Enable interaction
    entity.generateCollisionShapes(recursive: true) // Ensure all children have collision
    for child in entity.children {
        enableInteraction(for: child)
    }
}

// Highlight tapped entity
func highlightEntity(_ entity: Entity) {
    guard var modelComponent = entity.components[ModelComponent.self] else { return }
    let originalMaterials = modelComponent.materials // Save materials
    let highlightMaterial = SimpleMaterial(color: .yellow, isMetallic: false) // Highlight effect

    modelComponent.materials = [highlightMaterial]
    entity.components[ModelComponent.self] = modelComponent

    // Reset after 1 second
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        if var updatedComponent = entity.components[ModelComponent.self] {
            updatedComponent.materials = originalMaterials
            entity.components[ModelComponent.self] = updatedComponent
        }
    }
}

#Preview(windowStyle: .volumetric) {
    FemaleModelView()
        .volumeBaseplateVisibility( .visible)
        
}
