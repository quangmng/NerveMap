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
    @State private var angle = Angle(degrees: 1.0)

    @State var femaleModel: Entity?
    @State var maleModel: Entity?

    @State private var selectedEntity: Entity?
    @State private var originalTransform: Transform?
    @StateObject var noteVM = NoteViewModel()
    @State var initialScale: SIMD3<Float>? = nil
    @State private var AnnotationAnchor = AnchorEntity()
    let meshName: [ModelMesh] = [ModelMesh(name: "C1"), ModelMesh(name: "C2")]

    @EnvironmentObject var fvm: FunctionViewModel

    var body: some View {
                //3D model generation
                RealityView{ content, attachments in

                    let femaleEntity = await fvm.createFemaleModel()
                    let maleEntity = await fvm.createMaleModel()

                    femaleEntity.scale = SIMD3<Float>(0.5, 0.5, 0.5)
                    femaleEntity.position = SIMD3<Float>(0, -0.4, 0)

                    femaleModel = femaleEntity
                    maleModel = maleEntity

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
                    
                    
                }

                // MARK: -Gestures for model
                .simultaneousGesture(
                    ModelGestureFactory.tapGesture(
                        fvm: fvm,
                        selectedEntity: $selectedEntity
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
    }
}


#Preview(windowStyle: .volumetric) {
    MaleModelView()
        .volumeBaseplateVisibility( .visible)
        .environmentObject(FunctionViewModel())
}
