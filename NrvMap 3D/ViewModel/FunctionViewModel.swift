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
    
    @Published var style: ImmersionStyle = .mixed
    @Published var isMix: Bool = false
    @Published var isFull: Bool = false
    
    @Published var expendButton: Int? = nil
    
    @Published var isImmersive: Bool = false
    @Published var isMoving: Bool = false
    @Published var showStand: Bool = false
    @Published var showSit: Bool = false
    @Published var showWalk: Bool = true
    @Published var genderSelect: Bool = false
    @Published var isAnnotationMode = false
    
    @Published var modelEntity: Entity?
    @Published var selectedEntity: Entity?
    @Published var sitModel: Entity?
    @Published var standModel: Entity?
    @Published var walkModel: Entity?
    @Published var worldAnchor = AnchorEntity(world: SIMD3(x: 0, y:0, z: -1))
    
    @Published var position: String = ""
    @Published var simdPosition: SIMD3<Float> = [0,0,0]
    
    func enableInteraction(for entity: Entity) {
        entity.components
            .set(
                [InputTargetComponent(), HoverEffectComponent()]
            ) // Enable interaction
        entity.generateCollisionShapes(recursive: true)
        for child in entity.children {
            enableInteraction(for: child)
        }
    }
    
    func highlightEntity(_ entity: Entity) {
        guard var modelComponent = entity.components[ModelComponent.self] else { return }
        let originalMaterials = modelComponent.materials
        let highlightMaterial = SimpleMaterial(color: .yellow, isMetallic: false)
        
        modelComponent.materials = [highlightMaterial]
        entity.components[ModelComponent.self] = modelComponent
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if var updatedComponent = entity.components[ModelComponent.self] {
                updatedComponent.materials = originalMaterials
                entity.components[ModelComponent.self] = updatedComponent
            }
        }
    }
    
    func createModel(modelName: String) async -> Entity {
        guard let loadedEntity = try? await Entity(named: modelName, in: realityKitContentBundle) else {
            fatalError("Failed to load entity")
        }

        let parentEntity = Entity()

        // Compute model's bounds
        let bounds = loadedEntity.visualBounds(relativeTo: nil)
        let center = bounds.center

        // Shift children so center becomes pivot
        for child in loadedEntity.children {
            child.removeFromParent()
            child.position -= center  // recenters around midpoint
            parentEntity.addChild(child)
        }

        // Position the parent where the center used to be
        parentEntity.position = center
        let modelHeight = bounds.extents.y
        parentEntity.position.y += modelHeight / 2
        
        enableInteraction(for: parentEntity)
        return parentEntity
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

    func playAnimation() {
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
