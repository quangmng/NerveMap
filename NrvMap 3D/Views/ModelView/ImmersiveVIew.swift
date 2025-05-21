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
    @Environment(\.dismissWindow) private var dismissWindow
    @State private var angle = Angle(degrees: 1.0)
    @State private var selectedEntity: Entity?
    @State private var originalTransform: Transform?
    @State var initialScale: SIMD3<Float>? = nil
    @State private var currentGenderIsMale: Bool? = nil
    
    @StateObject var noteVM = NoteViewModel()
    @EnvironmentObject var fvm: FunctionViewModel
    
    @State private var currentRotation = simd_quatf(angle: 0, axis: [0, 1, 0])
    @State private var currentScale: Float = 1.0
    @State private var currentPosition = SIMD3<Float>(0, 0, -1)
    @State private var dragBoxEntity: ModelEntity?
    
    @Query(sort: \NoteData.dateCreated, order: .reverse) private var notes: [NoteData]
    
    var body: some View {
        
        RealityView{content, attachments in
            
            guard let skyboxEntity = fvm.createSkybox() else {
                print("Error loading entity")
                return
            }
            
            let femaleEntity = await fvm.createModel(modelName: "FemaleDermaModel")
            let maleEntity = await fvm.createModel(modelName: "MaleDermaModel")
            
            femaleEntity.position = SIMD3<Float>(x: -0.7, y: 0.7, z: -1)
            femaleEntity.scale = [1,1,1]
            maleEntity.position = SIMD3<Float>(x: -0.7, y: 0.7, z: -1)
            maleEntity.scale = [1,1,1]
            
            fvm.femaleModel = femaleEntity
            fvm.maleModel = maleEntity
            
            content.add(femaleEntity)
            
            if fvm.isMix == false{
                content.add(skyboxEntity)
            }

        }update:{ content, attachments in
            
            guard let male = fvm.maleModel, let female = fvm.femaleModel
            else{return}
            
            let selectedModel = fvm.genderSelect ? male : female
            let otherModel = fvm.genderSelect ? female : male
            
            if fvm.currentGenderIsMale != fvm.genderSelect {
                content.remove(otherModel)
                content.add(selectedModel)
            }
            
        }attachments:{
            
            
        }
        .gesture(
            DragGesture()
                .targetedToAnyEntity()
                .onChanged { value in
                    guard let entityF = fvm.femaleModel, let entityM = fvm.maleModel else { return }
                    
                    // Convert drag delta into radians
                    if fvm.showBox == true {}else{
                        let xRotation = Float(value.translation.height) * 0.005
                        let yRotation = Float(value.translation.width) * 0.005
                        
                        // Create new quaternions for each axis
                        let xQuat = simd_quatf(angle: xRotation, axis: [1, 0, 0])
                        let yQuat = simd_quatf(angle: yRotation, axis: [0, 1, 0])
                        
                        // Combine with previous rotation
                        entityF.transform.rotation = simd_normalize(yQuat * xQuat * currentRotation)
                        entityM.transform.rotation = simd_normalize(yQuat * xQuat * currentRotation)
                    }
                }
                .onEnded { value in
                    if fvm.showBox == true {}else{
                        
                        // Save final rotation for continuous spinning
                        let xRotation = Float(value.translation.height) * 0.005
                        let yRotation = Float(value.translation.width) * 0.005
                        
                        let xQuat = simd_quatf(angle: xRotation, axis: [1, 0, 0])
                        let yQuat = simd_quatf(angle: yRotation, axis: [0, 1, 0])
                        
                        currentRotation = simd_normalize(yQuat * xQuat * currentRotation)
                    }
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
        .simultaneousGesture(
            DragGesture()
                .targetedToAnyEntity()
                .onChanged { value in
                    if fvm.showBox == false{} else{
                        let delta = value.translation
                        let dx = Float(delta.width) * 0.0003
                        let dy = Float(delta.height) * -0.0003
                        
                        // Free movement in 3D space
                        if let modelF = fvm.femaleModel {
                            modelF.position += SIMD3<Float>(dx, dy, 0)
                        }
                        if let modelM = fvm.maleModel {
                            modelM.position += SIMD3<Float>(dx, dy, 0)
                        }
                    }
                }
        )
    }
}




#Preview{
    ImmersiveView()
        .environmentObject(FunctionViewModel())
}
