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
    
    @State private var currentRotation = simd_quatf(angle: 0, axis: [0, 1, 0])
    @State private var currentScale: Float = 1.0
    @State private var currentPosition = SIMD3<Float>(0, 0, -1)

    @EnvironmentObject var fvm: FunctionViewModel
    
    var body: some View {
                //3D model generation
        HStack{
            GeometryReader3D { geometry in
                RealityView{ content, attachments in
                    
                    let femaleEntity = await fvm.createModel(modelName: "FemaleDermaModel")
                    let maleEntity = await fvm.createModel(modelName: "MaleDermaModel")
                    
                    femaleEntity.scale = SIMD3<Float>(0.5, 0.5, 0.5)
                    femaleEntity.position = SIMD3<Float>(0, -0.1, 0)
                    
                    maleEntity.scale = SIMD3<Float>(0.5, 0.5, 0.5)
                    maleEntity.position = SIMD3<Float>(0, -0.1, 0)
                    
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
                
            }
            
            // MARK: -Gestures for model
            
            .gesture(
                       DragGesture()
                        .targetedToAnyEntity()
                           .onChanged { value in
                               guard let entityF = femaleModel, let entityM = maleModel else { return }

                               // Convert drag delta into radians
                               let xRotation = Float(value.translation.height) * 0.005
                               let yRotation = Float(value.translation.width) * 0.005

                               // Create new quaternions for each axis
                               let xQuat = simd_quatf(angle: xRotation, axis: [1, 0, 0])
                               let yQuat = simd_quatf(angle: yRotation, axis: [0, 1, 0])

                               // Combine with previous rotation
                               entityF.transform.rotation = simd_normalize(yQuat * xQuat * currentRotation)
                               
                               entityM.transform.rotation = simd_normalize(yQuat * xQuat * currentRotation)
                           }
                           .onEnded { value in
                               // Save final rotation for continuous spinning
                               let xRotation = Float(value.translation.height) * 0.005
                               let yRotation = Float(value.translation.width) * 0.005

                               let xQuat = simd_quatf(angle: xRotation, axis: [1, 0, 0])
                               let yQuat = simd_quatf(angle: yRotation, axis: [0, 1, 0])

                               currentRotation = simd_normalize(yQuat * xQuat * currentRotation)
                           }
                   )
            .simultaneousGesture(
                       MagnificationGesture()
                           .onChanged { value in
                               guard let entityF = femaleModel, let entityM = maleModel else { return }
                               let scale = Float(value)
                               entityF.transform.scale = [scale, scale, scale]
                               entityM.transform.scale = [scale, scale, scale]
                           }
                           .onEnded { value in
                               currentScale = Float(value)
                           }
                   )
            .simultaneousGesture(
                ModelGestureFactory.tapGesture(
                    fvm: fvm,
                    selectedEntity: $selectedEntity,
                    openWindow: {id in openWindow(id: id)}
                )
            )
            
//            .simultaneousGesture(
//                ModelGestureFactory.dragGesture(
//                    fvm: fvm,
//                    selectedEntity: $selectedEntity
//                )
//            )
//            .simultaneousGesture(
//                ModelGestureFactory.scaleGesture(
//                    fvm: fvm,
//                    initialScale: $initialScale
//                )
//            )
//            .simultaneousGesture(
//                ModelGestureFactory.rotationGesture(
//                    fvm: fvm,
//                    angle: $angle
//                )
//            )
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
                openWindow(id: "ModelDM")
            }
        }
    }
    
}


#Preview(windowStyle: .volumetric) {
    MaleModelView()
        .volumeBaseplateVisibility( .visible)
        .environmentObject(FunctionViewModel())
}
