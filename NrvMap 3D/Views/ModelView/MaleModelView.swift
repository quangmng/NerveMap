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
    @State private var currentGenderIsMale: Bool? = nil

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
                femaleEntity.position = SIMD3<Float>(0, -0.4, 0.3)
                
                maleEntity.scale = SIMD3<Float>(0.5, 0.5, 0.5)
                maleEntity.position = SIMD3<Float>(0, -0.4, 0.5)
                
                femaleModel = femaleEntity
                maleModel = maleEntity
                
                content.add(femaleEntity)
                
            }update:{content, attachments in
                
                guard let male = maleModel, let female = femaleModel, let button = attachments.entity(for: "button")
                else{return}
            
                let selectedModel = fvm.genderSelect ? male : female
                let otherModel = fvm.genderSelect ? female : male
                
                if currentGenderIsMale != fvm.genderSelect {
                       content.remove(otherModel)
                       content.add(selectedModel)
                   }
                
                button.position = fvm.simdPosition
                button.components.set([BillboardComponent(),HoverEffectComponent()])
                
                if let target = selectedModel.findEntity(named: fvm.position) {
                       target.addChild(button)
                    let bounds = target.visualBounds(relativeTo: selectedModel)
                        
                        // Position the button above the mesh
                        button.position = SIMD3<Float>(
                            bounds.center.x,
                            bounds.max.y + 0.2, // 2cm above top of mesh
                            bounds.center.z
                        )

                       
                       button.components.set([BillboardComponent(), HoverEffectComponent()])
                       print("Button added to \(target.name)")
                   }
                
            }
            attachments: {
                
                Attachment(id: "button"){
                    Button{
                        
                    }label:{
                        Text(fvm.position)
                    }
                        .toggleStyle(.button)
                        .buttonStyle(.borderless)
                        .labelStyle(.iconOnly)
                        .padding(12)
                        .glassBackgroundEffect(in: .rect(cornerRadius: 50))
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
    
}


#Preview(windowStyle: .volumetric) {
    MaleModelView()
        .volumeBaseplateVisibility( .visible)
        .environmentObject(FunctionViewModel())
}
