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
            
            if let buttonAttachment = attachments.entity(for: "button") {
                buttonAttachment.position = [0, -0.1, 0.3]
                walkModel.addChild(buttonAttachment)
            }
            
            if fvm.isMix == false{
                content.add(skyboxEntity)
            }

            walkModel.position = [0,0,-1]
            sitToStandModel.position = [0,0,-1]
            standToSitModel.position = [0,0,-1]
            content.add(walkModel)

        }update:{ content, attachments in
            
            guard let walkModel = walk, let sitModel = sitToStand, let standModel = standToSit, let buttonAttachment = attachments.entity(for: "button")
            else{return}
            
            if fvm.showSit == true {
    
                fvm.worldAnchor.addChild(sitModel)
                fvm.worldAnchor.removeChild(walkModel)
                fvm.worldAnchor.removeChild(standModel)
                
                sitModel.addChild(buttonAttachment)
                
                content.remove(walkModel)
                content.remove(standModel)
                content.add(sitModel)
                
            }else if fvm.showWalk == true{
                
                fvm.worldAnchor.addChild(walkModel)
                fvm.worldAnchor.removeChild(sitModel)
                fvm.worldAnchor.removeChild(standModel)
                
                walkModel.addChild(buttonAttachment)
                
                content.remove(sitModel)
                content.remove(standModel)
                content.add(walkModel)
                
            }else if fvm.showStand == true{
                
                fvm.worldAnchor.addChild(standModel)
                fvm.worldAnchor.removeChild(walkModel)
                fvm.worldAnchor.removeChild(sitModel)
                
                standModel.addChild(buttonAttachment)
                
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
                Attachment(id: "note") {
                    Text("\(list.title ?? "No title")")
                        .font(.headline)
                        .bold()
                }
            }
            
            Attachment(id: "button"){
                
                HStack(spacing: 10) {
                    
                    ExpendButton(id: 0, systemImage: fvm.genderSelect ? "figure.stand" : "figure.stand.dress", action: {fvm.genderSelect.toggle()}, extraButtons: [], expendButton: $fvm.expendButton)
                        .background(fvm.genderSelect ? Color.maleBule : Color.femalePink)
                        .cornerRadius(25)
                        .help("Gender")
                    
                    // i should ask...
                    ExpendButton(id: 1, systemImage: "figure.walk.motion", action: {openWindow(id:"MotionWindow")}, extraButtons: [
                         // action, label
                    ], expendButton: $fvm.expendButton)
                    .help("Animation")
                    
                    // TODO: merge this button with poses (enum)
                    ExpendButton(id: 2, systemImage: "square.stack.3d.up.fill", action: {openWindow(id: "Control")}, extraButtons: [], expendButton: $fvm.expendButton)
                        .help("Immersive")
                    
                    ExpendButton(id: 3, systemImage: "note.text", action: {}, extraButtons: [("note.text", {fvm.isAnnotationMode.toggle()}), ("list.clipboard", {openWindow(id: "NotesWindow")})], expendButton: $fvm.expendButton)
                        .help("Notes")
                    
                    ExpendButton(id: 4, systemImage: "info.circle.fill", action: {openWindow(id: "HelpWindow")}, extraButtons: [], expendButton: $fvm.expendButton)
                        .help("Info")
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
