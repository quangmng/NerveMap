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
import SwiftData

struct ImmersiveView: View {
    
    @Environment(\.openWindow) public var openWindow
    @State private var angle = Angle(degrees: 1.0)
    @State private var selectedEntity: Entity?
    @State private var originalTransform: Transform?
    @State var initialScale: SIMD3<Float>? = nil
    
    @StateObject var noteVM = NoteViewModel()
    @EnvironmentObject var fvm: FunctionViewModel
    
    @State var modelEntity: Entity?
    @State var standToSit: Entity?
    @State var sitToStand: Entity?
    @State var walk: Entity?
    
    @Query(sort: \NoteData.dateCreated, order: .reverse) private var notes: [NoteData]
    
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
                if fvm.isAnnotationMode {
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
            
            if fvm.isMix == false{
                content.add(skyboxEntity)
            }

            if let note = attachments.entity(for: "note"){
                note.position = SIMD3<Float>(0,0.5,0.5)
                walkModel.addChild(note)
            }
            
            walkModel.position = [0,0,-1]
            sitToStandModel.position = [0,0,-1]
            standToSitModel.position = [0,0,-1]
            content.add(walkModel)

        }update:{ content, attachments in
            
            guard let walkModel = walk, let sitModel = sitToStand, let standModel = standToSit
            else{return}
            
            if fvm.showSit == true {
    
                fvm.worldAnchor.addChild(sitModel)
                fvm.worldAnchor.removeChild(walkModel)
                fvm.worldAnchor.removeChild(standModel)
                
                content.remove(walkModel)
                content.remove(standModel)
                content.add(sitModel)
                
            }else if fvm.showWalk == true{
                
                fvm.worldAnchor.addChild(walkModel)
                fvm.worldAnchor.removeChild(sitModel)
                fvm.worldAnchor.removeChild(standModel)
        
                content.remove(sitModel)
                content.remove(standModel)
                content.add(walkModel)
                
            }else if fvm.showStand == true{
                
                fvm.worldAnchor.addChild(standModel)
                fvm.worldAnchor.removeChild(walkModel)
                fvm.worldAnchor.removeChild(sitModel)
                
                content.remove(sitModel)
                content.remove(walkModel)
                content.add(standModel)
                
            }
            
            for list in notes {
                if let listEntity = attachments.entity(for: "note"){
                    content.add(listEntity)
                }
            }
        }attachments:{
            
            ForEach(notes) { list in
                Attachment(id: "note") {
                    Text("\(list.title)")
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
