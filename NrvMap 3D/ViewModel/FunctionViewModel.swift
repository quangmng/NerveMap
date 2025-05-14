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
        entity.generateCollisionShapes(recursive: true) // Ensure all children have collision
        for child in entity.children {
            enableInteraction(for: child)
        }
    }
    
    func highlightEntity(_ entity: Entity) {
        guard var modelComponent = entity.components[ModelComponent.self] else { return }
        let originalMaterials = modelComponent.materials // Save materials
        let highlightMaterial = SimpleMaterial(color: .yellow, isMetallic: false) // Highlight effect
        
        modelComponent.materials = [highlightMaterial]
        entity.components[ModelComponent.self] = modelComponent
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if var updatedComponent = entity.components[ModelComponent.self] {
                updatedComponent.materials = originalMaterials
                entity.components[ModelComponent.self] = updatedComponent
            }
        }
    }
    
    func createFemaleModel() async -> Entity{
            
           guard let modelEntity = try? await Entity(named: "FemaleDermaModel", in: realityKitContentBundle) else {
               
               fatalError("Fail to load entity")
               
            }
            enableInteraction(for: modelEntity)
            
            
            return modelEntity
            
        }
    
    func createMaleModel() async -> Entity{
            
           guard let modelEntity = try? await Entity(named: "MaleDermaModel", in: realityKitContentBundle) else {
               
               fatalError("Fail to load entity")
               
            }
            enableInteraction(for: modelEntity)
            
            
            return modelEntity
            
        }
    
    func createWalkingModel() async -> Entity{
            
           guard let modelEntity = try? await Entity(named: "MaleWalk", in: realityKitContentBundle) else {
               
               fatalError("Fail to load entity")
               
            }
            enableInteraction(for: modelEntity)
            
            return modelEntity
            
        }
    
    func createSitToStandModel() async -> Entity{
        
        guard let modelEntity = try? await Entity(named: "MaleSit", in: realityKitContentBundle) else {
            
            fatalError("Fail to load entity")
           
        }
        enableInteraction(for: modelEntity)
        
        return modelEntity
    }
    
    func createStandToSitModel() async -> Entity{
        
        guard let modelEntity = try? await Entity(named: "MaleStand", in: realityKitContentBundle) else {
            
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
