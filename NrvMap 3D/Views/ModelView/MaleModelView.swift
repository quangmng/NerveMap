//
//  MaleModelView.swift
//  NrvMap 3D
//
//  Created by Ian So on 26/3/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct MaleModelView: View {
    
    @Environment(\.openWindow) public var openWindow
    @State private var angle = Angle(degrees: 1.0)
    
    @State var femaleModel: Entity? = nil
    @State var maleModel: Entity?
    @State var currentModel: Entity? = nil
    
    @State private var selectedEntity: Entity?
    @State private var originalTransform: Transform?
    @State private var isAnnotationMode = false
    @StateObject var fvm = FunctionViewModel()
    @StateObject var noteVM = NoteViewModel()
    @State var initialScale: SIMD3<Float>? = nil
    @State private var AnnotationAnchor = AnchorEntity()
    @State private var genderSelect: Bool = false
    @State private var expendButton: Int? = nil
    @State private var activeID: Int?
    @State private var showingMotion: Bool = false
    
    var tap: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { event in
                if isAnnotationMode {
                    print("gesture blocked")
                }else{
                    selectedEntity = event.entity
                    fvm.highlightEntity(event.entity)
                }
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
                if isAnnotationMode {
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
                if isAnnotationMode {
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
                    currentModel = femaleEntity
                    
                    femaleEntity.scale = SIMD3<Float>(0.5, 0.5, 0.5)
                    femaleEntity.position = SIMD3<Float>(0, -0.5, 0)
                    AnnotationAnchor.position = [0, -0.9, 0]
                    femaleEntity.addChild(AnnotationAnchor)
                    fvm.enableInteraction(for: femaleEntity)
                    content.add(femaleEntity)
                    femaleModel = femaleEntity
                    maleModel = maleEntity
                    originalTransform = femaleEntity.transform
                    
                    
                    
                }update:{content, attachments in
                    
                    guard let male = maleModel, let female = femaleModel
                    else{return}
                    
                    if !genderSelect{
                        currentModel == female
                        content.remove(male)
                        content.add(female)
                        
                    }else if genderSelect {
                        currentModel == male
                        content.remove(female)
                        content.add(male)
                        
                    }
                    
                    for list in noteVM.notes {
                        if let listEntity = attachments.entity(for: list.id){
                            content.add(listEntity)
                        }
                    }
                    if let entity = content.entities.first(where: { $0.name == "MainModel" }) {
                        entity.move(to: Transform(translation: [0, 0.3, -1.2]), relativeTo: nil, duration: 5.0)
                    }
                    
                }
                attachments: {
                    ForEach(noteVM.notes) { list in
                        Attachment(id: list.id) {
                            
                            
                        }
                    }
                }
                
                //Gesture
                
                .gesture(SpatialTapGesture()
                    .targetedToAnyEntity()
                    .onEnded{value in
                        if isAnnotationMode == false{
                            print("gesture blocked")
                        }else{
                            let location = value.location3D
                            let convertedLocaiton = 1.1 * value.convert(location , from: .local, to: .scene)
                            noteVM.pendingLocation = convertedLocaiton
                            openWindow(id: "AnnotationWindow")
                        }
                    })
                .simultaneousGesture(rotation)
                .simultaneousGesture(scaleGesture)
                .simultaneousGesture(drag)
                .simultaneousGesture(tap)
                
                /*
                VStack {
                    Spacer().frame(width: 600)
                    HStack {
                        
                        // TODO: swiching gender - Motion - Simulation - Note taking - Info
                        
                        
                        ExpendButton(id: 0, systemImage: "figure.stand", action: {}, extraButtons: [("figure.stand", {genderSelect = false}),("figure.stand.dress", {genderSelect = true})], expendButton: $expendButton)
                        
                        ExpendButton(id: 1, systemImage: "figure.walk.motion", action: {}, extraButtons: [("note.text", {isAnnotationMode.toggle()})], expendButton: $expendButton)
                        
                        ExpendButton(id: 2, systemImage: "house", action: {}, extraButtons: [("note.text", {openWindow(id: "Control")})], expendButton: $expendButton)
                    }
                    .background(Color.gray.cornerRadius(30))
                }
                 */
            }
        }
        .background{
            if isAnnotationMode == true {
                Color.black.opacity(0.5)
            }
        }
        .ornament(attachmentAnchor: .scene(.bottomFront)) {
            HStack(spacing: 10) {                
                
                ExpendButton(id: 0, systemImage: genderSelect ? "figure.stand" : "figure.stand.dress", action: {genderSelect.toggle()}, extraButtons: [], expendButton: $expendButton)
                    .background(genderSelect ? Color.maleBule : Color.femalePink)
                    .cornerRadius(25)
                
                // i should ask...
                ExpendButton(id: 1, systemImage: "figure.walk.motion", action: {openWindow(id:"MotionWindow")}, extraButtons: [
                     // action, label
                ], expendButton: $expendButton)
                
                ExpendButton(id: 2, systemImage: "square.stack.3d.up.fill", action: {openWindow(id: "Control")}, extraButtons: [], expendButton: $expendButton)
                
                ExpendButton(id: 3, systemImage: "note.text", action: {}, extraButtons: [("note.text", {isAnnotationMode.toggle()}), ("list.clipboard", {openWindow(id: "NotesWindow")})], expendButton: $expendButton)
                
                ExpendButton(id: 4, systemImage: "info.circle.fill", action: {openWindow(id: "HelpWindow")}, extraButtons: [], expendButton: $expendButton)
            }
        }
    }
}


#Preview(windowStyle: .volumetric) {
    MaleModelView()
        .volumeBaseplateVisibility( .visible)
}
