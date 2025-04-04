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
    
    @State private var angle = Angle(degrees: 1.0)
    @State private var modelEntity: Entity?
    @State private var selectedEntity: Entity?
    @State private var originalTransform: Transform?
    @State private var isAnnotationMode = false
    @StateObject var fvm = FunctionViewModel()
    @State var initialScale: SIMD3<Float>? = nil
    
    var tap: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { event in
                selectedEntity = event.entity
                fvm.highlightEntity(event.entity)
            }
    }
    
    var drag: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { event in
                if isAnnotationMode {
                    print("gesture blocked")
                }else{
                    if let entity = selectedEntity {
                        let delta = SIMD3<Float>(Float(event.translation.width) * -0.0001, 0, Float(event.translation.height) * -0.0001)
                        entity.transform.translation += delta
                    }
                }
            }
            .onEnded { _ in print("Drag ended") }
    }
    
    var scaleGesture: some Gesture {
        MagnifyGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                let rootEntity = value.entity
                if initialScale == nil {
                    initialScale = rootEntity.scale
                }
                let scaleRate: Float = 1.0
                rootEntity.scale = (initialScale ?? .init(repeating: scaleRate)) * Float(value.gestureValue.magnification)
            }
            .onEnded { _ in
                initialScale = nil
            }
    }
    
    var rotation: some Gesture {
           RotateGesture()
               .onChanged { value in
                   angle = value.rotation
               }
       }
    
    var body: some View {
        
        RealityView{content in
            
            guard let skyboxEntity = createSkybox() else {
                print("Error loading entity")
                return
            }
            
            let model = await create3DModel()
            
            content.add(skyboxEntity)
            content.add(model)
            
        }
        .simultaneousGesture(rotation)
        .simultaneousGesture(scaleGesture)
        .simultaneousGesture(drag)
        .simultaneousGesture(tap)
    }
    
    private func create3DModel() async -> Entity{
        
       guard let modelEntity = try? await Entity(named: "Scene", in: realityKitContentBundle) else {
           
           fatalError("Fail to load entity")
           
        }
        fvm.enableInteraction(for: modelEntity)
        
        
        return modelEntity
        
    }

    private func createSkybox() -> Entity?{
        
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


#Preview{
    Model3DViewTest()
}
