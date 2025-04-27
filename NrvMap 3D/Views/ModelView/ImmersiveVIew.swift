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

struct ImmersiveView: View {
    
    @State private var angle = Angle(degrees: 1.0)
    @State var modelEntity: Entity?
    @State private var selectedEntity: Entity?
    @State private var originalTransform: Transform?
    @State private var isAnnotationMode = false
    @StateObject var fvm = FunctionViewModel()
    @State var initialScale: SIMD3<Float>? = nil
    @EnvironmentObject var ivm: ImmersiveViewModel
    
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
                        let delta = SIMD3<Float>(Float(event.translation.width) * 0.0001, 0, Float(event.translation.height) * -0.0001)
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
            
            let worldAnchor = AnchorEntity(world: SIMD3(x: 0, y:0, z: -1))
            
            guard let skyboxEntity = fvm.createSkybox() else {
                print("Error loading entity")
                return
            }
            
            let model = await fvm.createMaleModel()
            
            worldAnchor.addChild(model)
            
            content.add(skyboxEntity)
            content.add(model)
            
            ivm.modelEntity = model
           
            
        }
        .simultaneousGesture(rotation)
        .simultaneousGesture(scaleGesture)
        .simultaneousGesture(drag)
        .simultaneousGesture(tap)
    }
    
}




#Preview{
    ImmersiveView()
}
