//
//  ModelView.swift
//  NrvMap 3D
//
//  Created by Ian So on 25/3/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct FemaleModelView: View {

    @State private var selectedEntity: Entity? // Stores tapped entity
    @State private var modelEntity: Entity? // Stores full model
    @State private var originalTransform: Transform? // Stores original position
    
    var body: some View {
        HStack{
            ZStack{
                
                RealityView { content in
                    
                    do {
                        let entity = try await Entity.load(named: "FemaleDModel")
                        
                        entity.scale = SIMD3<Float>(0.5, 0.5, 0.5) // Try a smaller scale
                        
                        
                        entity.generateCollisionShapes(recursive: true) // Enable tap & drag
                        
                        entity.position = SIMD3<Float>(0, -0.5, 0)
                        
                        enableInteraction(for: entity)
                        content.add(entity)
                        
                        modelEntity = entity // Store the model
                        
                        originalTransform = entity.transform // Save original position
                        
                        
                    }
                    catch {
                        print("Failed to load model: \(error)")
                    }
                }
                
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
                
                
                HStack{
                    Spacer()
                        .frame(width: 600)
                    VStack{
                        
                        Button(){
                            
                            
                        }label:{
                            Image(systemName: "house")
                        }
                        .frame(width: 50, height: 50)
                        .padding()
                        
                        
                        Button(){
                            
                            
                        }label:{
                            Image(systemName: "square.resize")
                        }
                        .frame(width: 50, height: 50)
                        .padding()
                        
                        Button(){
                            
                            
                        }label:{
                            Image(systemName: "move.3d")
                        }
                        .frame(width: 50, height: 50)
                        .padding()
                        
                        Button(){
                            
                            
                        }label:{
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
