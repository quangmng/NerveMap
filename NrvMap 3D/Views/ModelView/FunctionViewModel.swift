//
//  FunctionViewModel.swift
//  NrvMap 3D
//
//  Created by Ian So on 30/3/2025.
//

import Foundation
import RealityKit
import SwiftUI
import RealityKitContent

class FunctionViewModel: ObservableObject {
    
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
    
    func create3DModel() async -> Entity{
            
           guard let modelEntity = try? await Entity(named: "Scene", in: realityKitContentBundle) else {
               
               fatalError("Fail to load entity")
               
            }
            enableInteraction(for: modelEntity)
            
            
            return modelEntity
            
        }
    
    func createSkybox() -> Entity?{
            
            let largeSphere = MeshResource.generateSphere(radius: 1000.0)
            
            var skyboxMaterial = UnlitMaterial()
            
            do{
                let texture = try TextureResource.load(named: "Hospital")
                skyboxMaterial.color = .init(texture: .init(texture))
            }catch{
                print("Error: \(error)")
            }
            
            let skyBoxEntity = Entity()
            skyBoxEntity.components.set(ModelComponent(mesh: largeSphere, materials: [skyboxMaterial]))
            
            skyBoxEntity.scale *= .init(x: -1, y: 1, z: 1)
            
            return skyBoxEntity
            
        }

    
}
