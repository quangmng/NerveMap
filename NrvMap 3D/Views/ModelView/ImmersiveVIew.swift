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
    @State private var currentGenderIsMale: Bool? = nil
    
    @StateObject var noteVM = NoteViewModel()
    @EnvironmentObject var fvm: FunctionViewModel
    
    @State private var currentRotation = simd_quatf(angle: 0, axis: [0, 1, 0])
    @State private var currentScale: Float = 1.0
    @State private var currentPosition = SIMD3<Float>(0, 0, -1)
    
    @State var femaleModel: Entity?
    @State var maleModel: Entity?
    
    @Query(sort: \NoteData.dateCreated, order: .reverse) private var notes: [NoteData]
    
    var body: some View {
        
        RealityView{content, attachments in
            
            guard let skyboxEntity = fvm.createSkybox() else {
                print("Error loading entity")
                return
            }
            
            let femaleEntity = await fvm.createModel(modelName: "FemaleDermaModel")
            let maleEntity = await fvm.createModel(modelName: "MaleDermaModel")
            
            femaleModel = femaleEntity
            maleModel = maleEntity
            
            content.add(femaleEntity)
            
            if fvm.isMix == false{
                content.add(skyboxEntity)
            }

        }update:{ content, attachments in
            
            guard let male = maleModel, let female = femaleModel, let button = attachments.entity(for: "button")
            else{return}
            
            let selectedModel = fvm.genderSelect ? male : female
            let otherModel = fvm.genderSelect ? female : male
            
            if currentGenderIsMale != fvm.genderSelect {
                content.remove(otherModel)
                content.add(selectedModel)
            }
            
            
        }attachments:{
            
            
        }
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
    }
}




#Preview{
    ImmersiveView()
        .environmentObject(FunctionViewModel())
}
