//
//  MaleModelView.swift
//  NrvMap 3D
//
//  Created by Ian So on 26/3/2025.
//

import SwiftUI
import SwiftData
import RealityKit
import RealityKitContent


struct MaleModelView: View {

    @Query(sort: \NoteData.dateCreated, order: .reverse) private var notes: [NoteData]

    @StateObject var nvm = NoteViewModel()
    @Environment(\.openWindow) public var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @State private var angle = Angle(degrees: 1.0)

    @State var femaleModel: Entity?
    @State var maleModel: Entity?

    @State private var selectedEntity: Entity?
    @State private var originalTransform: Transform?
    @StateObject var noteVM = NoteViewModel()
    @State var initialScale: SIMD3<Float>? = nil
    @State private var AnnotationAnchor = AnchorEntity()
    let meshName: [ModelMesh] = [ModelMesh(name: "C1"), ModelMesh(name: "C2")]
    @State private var buttonEntities: [Entity] = []

    @EnvironmentObject var fvm: FunctionViewModel

    var body: some View {
                //3D model generation
        HStack{
            RealityView{ content, attachments in
                
                let femaleEntity = await fvm.createFemaleModel()
                let maleEntity = await fvm.createMaleModel()
                
                femaleEntity.scale = SIMD3<Float>(0.5, 0.5, 0.5)
                femaleEntity.position = SIMD3<Float>(0, -0.4, 0)
                
                femaleModel = femaleEntity
                maleModel = maleEntity
                
                if let buttonAttachments = attachments.entity(for: "button") {
                    buttonAttachments.position = [0, -0.4, 0.2]
                    femaleEntity.addChild(buttonAttachments)
                    maleEntity.addChild(buttonAttachments)
                }
                
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
                
            }
            attachments: {
                
                Attachment(id: "button"){
                    Button{
                        openWindow(id: "Control")
                    }label:{
                        Text("Testing")
                    }.background(Color.red)
                }
                
            }
            
            // MARK: -Gestures for model
            .simultaneousGesture(
                ModelGestureFactory.tapGesture(
                    fvm: fvm,
                    selectedEntity: $selectedEntity,
                    openWindow: {id in openWindow(id: id)}
                )
            )
            .simultaneousGesture(
                ModelGestureFactory.dragGesture(
                    fvm: fvm,
                    selectedEntity: $selectedEntity
                )
            )
            .simultaneousGesture(
                ModelGestureFactory.scaleGesture(
                    fvm: fvm,
                    initialScale: $initialScale
                )
            )
            .simultaneousGesture(
                ModelGestureFactory.rotationGesture(
                    fvm: fvm,
                    angle: $angle
                )
            )
            .background{
                if fvm.isAnnotationMode == true {
                    Color.black.opacity(0.5)
                }
            }
            .ornament(attachmentAnchor: .scene(.bottomFront)) {
                ButtonBoard()
            }
        }.onAppear{
            dismissWindow(id: "launch")
        }
        
        .onDisappear{
            if fvm.isImmersive == false{
                openWindow(id: "WelcomeView")
            }
        }
    }
    
    func addButton(in root: Entity){
        if root.components[ModelComponent.self] != nil {
            attachButton(to: root)
        }
        
        for child in root.children {
            addButton(in: child)
        }
    }

    func attachButton(to entity: Entity){
        
        let buttonSize: Float = 0.03
        let mesh = MeshResource.generateSphere(radius: buttonSize)
        let material = SimpleMaterial(color: .red, isMetallic: false)
        let buttonEntity = ModelEntity(mesh: mesh, materials: [material])
        
        buttonEntity.position = entity.position + [0,0,0.2]
        buttonEntity.components.set(InputTargetComponent())
        buttonEntity.components.set(CollisionComponent(shapes: [ShapeResource.generateSphere(radius: buttonSize)]))
        
        entity.addChild(buttonEntity)
        buttonEntities.append(buttonEntity)
        
    }
    
}


#Preview(windowStyle: .volumetric) {
    MaleModelView()
        .volumeBaseplateVisibility( .visible)
        .environmentObject(FunctionViewModel())
}
