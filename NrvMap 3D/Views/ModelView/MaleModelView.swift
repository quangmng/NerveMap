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

    @State private var selectedEntity: Entity?
    @StateObject var noteVM = NoteViewModel()
    
    @State private var currentRotation = simd_quatf(angle: 0, axis: [0, 1, 0])
    @State private var currentScale: Float = 1.0
    @State private var currentPosition = SIMD3<Float>(0, 0, -1)

    @EnvironmentObject var fvm: FunctionViewModel
    
    var body: some View {
                //3D model generation
        HStack{
           
                RealityView{ content, attachments in
                    
                    let femaleEntity = await fvm.createModel(modelName: "FemaleDermaModel")
                    let maleEntity = await fvm.createModel(modelName: "MaleDermaModel")
                    
                    femaleEntity.scale = SIMD3<Float>(0.5, 0.5, 0.5)
                    femaleEntity.position = SIMD3<Float>(0, -0.3, 0)
                    
                    maleEntity.scale = SIMD3<Float>(0.5, 0.5, 0.5)
                    maleEntity.position = SIMD3<Float>(0, -0.3, 0)
                    
                    fvm.femaleModel = femaleEntity
                    fvm.maleModel = maleEntity
                    
                    content.add(maleEntity)
                    
                }update:{content, attachments in
                    
                    guard let male = fvm.maleModel, let female = fvm.femaleModel
                    else{return}
                    
                    let selectedModel = fvm.genderSelect ? male : female
                    let otherModel = fvm.genderSelect ? female : male
                    
                    if fvm.currentGenderIsMale != fvm.genderSelect {
                        content.remove(otherModel)
                        content.add(selectedModel)
                    }
                }
            attachments: {
            }
            
            // MARK: -Gestures for model
            
            .gesture(
                       DragGesture()
                        .targetedToAnyEntity()
                           .onChanged { value in
                               guard let entityF = fvm.femaleModel, let entityM = fvm.maleModel else { return }

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
                               guard let entityF = fvm.femaleModel, let entityM = fvm.maleModel else { return }
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
            .simultaneousGesture(
                TapGesture(count:2).targetedToAnyEntity()
                    .onEnded{value in
                        fvm.selectedEntity = value.entity
                        openWindow(id: "InfoWindow")
                        print("Double Tap \(fvm.selectedEntity?.name ?? "No Entity")")
                    }
            )
            .ornament(attachmentAnchor: .scene(.bottomFront)) {
                ButtonBoard()
            }
        }.onAppear{
            dismissWindow(id: "launch")
            dismissWindow(id: "HelpWindow")
        }
    }
    
}


#Preview(windowStyle: .volumetric) {
    MaleModelView()
        .volumeBaseplateVisibility( .visible)
        .environmentObject(FunctionViewModel())
}
