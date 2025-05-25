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

    @Published var expandButton: Int? = nil

    @Published var isImmersive: Bool = false
    @Published var isMoving: Bool = false
    @Published var showBox: Bool = false

    @Published var showSit: Bool = false
    @Published var showWalk: Bool = true
    @Published var genderSelect: Bool = false
    @Published var isAnnotationMode = false
    @Published var isMale: Bool = false
    @Published var currentGenderIsMale: Bool? = nil

    @Published var femaleModel: Entity?
    @Published var maleModel: Entity?
    @Published var modelEntity: Entity?
    @Published var selectedEntity: Entity?
    @Published var sitModel: Entity?
    @Published var standModel: Entity?
    @Published var walkModel: Entity?
    @Published var worldAnchor = AnchorEntity(world: SIMD3(x: 0, y:0, z: -1))

    @Published var position: String = ""
    @Published var simdPosition: SIMD3<Float> = [0,0,0]

    var blinkingTimers: [Entity: Timer] = [:]
    var originalMaterials: [Entity: [RealityKit.Material]] = [:]
    var cachedOriginalMaterials: [ObjectIdentifier: [RealityKit.Material]] = [:]

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

    func highlightEntity(_ entity: Entity, duration: TimeInterval = 1.0) {
        guard var modelComponent = entity.components[ModelComponent.self] else { return }
        let id = ObjectIdentifier(entity)

        // Cache original materials only if not already cached
        if cachedOriginalMaterials[id] == nil {
            cachedOriginalMaterials[id] = modelComponent.materials
        }

        // Apply highlight material
        let highlightMaterial = SimpleMaterial(color: .yellow, isMetallic: false)
        modelComponent.materials = [highlightMaterial]
        entity.components[ModelComponent.self] = modelComponent

        // Schedule return to original materials
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [self] in
            guard var updatedComponent = entity.components[ModelComponent.self],
                  let original = cachedOriginalMaterials[id] else { return }

            updatedComponent.materials = original
            entity.components[ModelComponent.self] = updatedComponent
            cachedOriginalMaterials.removeValue(forKey: id)
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

    func startBlinkingHighlight(for entity: Entity, interval: TimeInterval = 0.5) {
        guard blinkingTimers[entity] == nil,
              var modelComponent = entity.components[ModelComponent.self] else { return }

        // Save original materials if not already saved
        if originalMaterials[entity] == nil {
            originalMaterials[entity] = modelComponent.materials
        }

        let highlightMaterial = SimpleMaterial(color: .yellow, isMetallic: false)

        var isOn = false

        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak entity] _ in
            guard let entity = entity,
                  var model = entity.components[ModelComponent.self],
                  let original = self.originalMaterials[entity] else { return }

            model.materials = isOn ? original : [highlightMaterial]
            entity.components[ModelComponent.self] = model
            isOn.toggle()
        }

        blinkingTimers[entity] = timer
    }

    func stopBlinkingHighlight(for entity: Entity) {
        guard let timer = blinkingTimers[entity],
              var modelComponent = entity.components[ModelComponent.self],
              let original = originalMaterials[entity] else { return }

        timer.invalidate()
        blinkingTimers.removeValue(forKey: entity)
        originalMaterials.removeValue(forKey: entity)

        modelComponent.materials = original
        entity.components[ModelComponent.self] = modelComponent
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
