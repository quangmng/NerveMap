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
    @State private var selectedEntity: Entity?
    @State private var originalTransform: Transform?
    @State private var isAnnotationMode = false
    @State var initialScale: SIMD3<Float>? = nil
    
    @StateObject var noteVM = NoteViewModel()
    @EnvironmentObject var fvm: FunctionViewModel
    
    @State var modelEntity: Entity?
    @State var standToSit: Entity?
    @State var sitToStand: Entity?
    @State var walk: Entity?
    
    
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
        
        RealityView{content, attachments in
            
            let worldAnchor = AnchorEntity(world: SIMD3(x: 0, y:0, z: -1))
            
            guard let skyboxEntity = fvm.createSkybox() else {
                print("Error loading entity")
                return
            }
            
            let walkModel = await fvm.createWalkingModel()
            fvm.walkModel = walkModel
            walk = walkModel
            
            let sitToStandModel = await fvm.createSitToStandModel()
            fvm.sitModel = sitToStandModel
            sitToStand = sitToStandModel
            
            let standToSitModel = await fvm.createStandToSitModel()
            fvm.standModel = standToSitModel
            standToSit = standToSitModel
            
            worldAnchor.addChild(walkModel)
            
            content.add(skyboxEntity)
            content.add(walkModel)
            
            fvm.modelEntity = walkModel
            
        }update:{ content, attachments in
            
            guard let walkModel = walk, let sitModel = sitToStand, let standModel = standToSit
            else{return}
            
            if fvm.showSit == true {
    
                content.remove(walkModel)
                content.remove(standModel)
                content.add(sitModel)
                
            }else if fvm.showWalk == true{
                
                content.remove(sitModel)
                content.remove(standModel)
                content.add(walkModel)
                
            }else if fvm.showStand == true{
                
                content.remove(sitModel)
                content.remove(walkModel)
                content.add(standModel)
                
            }
            
            
            for list in noteVM.notes {
                if let listEntity = attachments.entity(for: list.id){
                    content.add(listEntity)
                }
            }
            if let entity = content.entities.first(where: { $0.name == "modelEntity" }) {
                entity.move(to: Transform(translation: [0, 0.3, -1.2]), relativeTo: nil, duration: 5.0)
            }
            
        }attachments:{
            
            ForEach(noteVM.notes) { list in
                Attachment(id: list.id) {
                    Text("\(list.title ?? "No title")")
                        .font(.headline)
                        .bold()
                }
            }
            
            
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
