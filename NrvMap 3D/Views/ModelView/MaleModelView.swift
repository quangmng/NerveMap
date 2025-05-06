//
//  MaleModelView.swift
//  NrvMap 3D
//
//  Created by Ian So on 26/3/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent
import SwiftData

struct MaleModelView: View {
    
    @Query(sort: \NoteData.dateCreated, order: .reverse) private var notes: [NoteData]
    
    @StateObject var nvm = NoteViewModel()
    @Environment(\.openWindow) public var openWindow
    @State private var angle = Angle(degrees: 1.0)
    
    @State var femaleModel: Entity? = nil
    @State var maleModel: Entity?
    
    @State private var selectedEntity: Entity?
    @State private var originalTransform: Transform?
    @StateObject var noteVM = NoteViewModel()
    @State var initialScale: SIMD3<Float>? = nil
    @State private var AnnotationAnchor = AnchorEntity()
    
    @EnvironmentObject var fvm: FunctionViewModel
    
    var tap: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { event in
                if fvm.isAnnotationMode {
                    fvm.selectedEntity = event.entity
                    fvm.highlightEntity(event.entity)
                    fvm.position = event.entity.name
                    openWindow(id: "AnnotationWindow")
                }else{
                    fvm.selectedEntity = event.entity
                    fvm.position = event.entity.name
                    fvm.highlightEntity(event.entity)
                    print("\(event.entity.name)")
                }
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
                if fvm.isAnnotationMode {
                    print("gesture blocked")
                }else{
                    let rootEntity = value.entity
                    if initialScale == nil {
                        initialScale = rootEntity.scale
                    }
                    let scaleRate: Float = 1.0
                    rootEntity.scale = (initialScale ?? .init(repeating: scaleRate)) * Float(value.gestureValue.magnification)
                }
            }
            .onEnded { _ in
                initialScale = nil
            }
    }
    
    var rotation: some Gesture {
        RotateGesture()
            .onChanged { value in
                if fvm.isAnnotationMode {
                    print("gesture blocked")
                }else{
                    angle = value.rotation
                }
            }
    }

    
    var body: some View {
        
        HStack {
            ZStack {
                
                //3D model generation
                RealityView{ content, attachments in
                    
                    let femaleEntity = await fvm.createFemaleModel()
                    let maleEntity = await fvm.createMaleModel()
                    
                    femaleEntity.scale = SIMD3<Float>(0.5, 0.5, 0.5)
                    femaleEntity.position = SIMD3<Float>(0, -0.4, 0)
                    
                    if let note = attachments.entity(for: notes.first?.id){
                        note.position = SIMD3<Float>(0,0.5,0.5)
                        femaleEntity.addChild(note)
                    }
                    
//                    for note in notes {
//                        
//                        let noteAttachment
//                    }
                    
                    femaleModel = femaleEntity
                    maleModel = maleEntity
                    
                    nvm.notes = notes
                    
                    content.add(femaleEntity)
                    
                }update:{content, attachments in
                    
                    guard let male = maleModel, let female = femaleModel
                    else{return}
                    
                    if !fvm.genderSelect{
                       
                        content.remove(male)
                        content.add(female)
                        
                    }else if fvm.genderSelect {
                        
                       
                        content.remove(female)
                        content.add(male)
                        
                    }
                    
                    for note in notes {
                        if let listEntity = attachments.entity(for: note.id){
                            content.add(listEntity)
                        }
                    }
                }
                attachments: {
                    ForEach(notes) { note in
                        Attachment(id: note.id) {
                            Text("\(note.title)")
                                .font(.extraLargeTitle)
                                .background(Color.black)
                            
                        }
                    }
                }

                
                //Gesture
                
                .simultaneousGesture(rotation)
                .simultaneousGesture(scaleGesture)
                .simultaneousGesture(drag)
                .simultaneousGesture(tap)
            }
        }
        .background{
            if fvm.isAnnotationMode == true {
                Color.black.opacity(0.5)
            }
        }
        .ornament(attachmentAnchor: .scene(.bottomFront)) {
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
}


#Preview(windowStyle: .volumetric) {
    MaleModelView()
        .volumeBaseplateVisibility( .visible)
}
