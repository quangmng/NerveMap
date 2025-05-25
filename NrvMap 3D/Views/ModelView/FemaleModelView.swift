//
//  ModelView.swift
//  NrvMap 3D
//
//  Created by Ian So on 25/3/2025.
//

import SwiftUI
import RealityKit

struct FemaleModelView: View {

    @Environment(\.openWindow) public var openWindow
    @State private var modelEntity: Entity?
    @State private var selectedEntity: Entity?
    @State private var originalTransform: Transform?
    @State private var genderSelection: Bool = false
    @StateObject var fvm = FunctionViewModel()
    @Environment(AnnotationViewModel.self) private var avm
    @State var isAnnotationMode: Bool = false

    var body: some View {
        HStack {
            ZStack {
                RealityView { content, attachments in
                    do {
                        let modelName = genderSelection ? "MaleDModel" : "FemaleDModel"
                        let entity = try await ModelEntity(named: "FemaleDModel") //try this line to fix the warnings
                        entity.scale = SIMD3<Float>(0.5, 0.5, 0.5)
                        entity.generateCollisionShapes(recursive: true) // Enable tap & drag
                        entity.position = SIMD3<Float>(x: -0.1, y: -0.5, z: -0.05)

                        fvm.enableInteraction(for: entity)
                        content.add(entity)
                        
                        modelEntity = entity
                        originalTransform = entity.transform // Save original position
                    } catch {
                        print("Failed to load model: \(error)")
                    }
                } update:{content, attachments in
                    for list in avm.annotationList {
                        if let listEntity = attachments.entity(for: list.id){
                            content.add(listEntity)
                        }
                    }
                }
                attachments: {
                    ForEach(avm.annotationList) { list in
                        Attachment(id: list.id) {
                            Button("\(list.title)"){
                                openWindow(id: "ModelDM")
                            }
                        }
                    }
                }

                .gesture(SpatialTapGesture()
                    .targetedToAnyEntity()
                    .onEnded{value in
                        if isAnnotationMode == false{
                            print("gesture blocked")
                        }else{
                            let location = value.location3D
                            let convertedLocaiton = 1.1 * value.convert(location , from: .local, to: .scene)
                            avm.pendingLocation = convertedLocaiton
                            openWindow(id: "AnnotationWindow")
                        }
                    })
                // **Add Drag & Tap Gestures for Interaction**
                // Drag Gesture
                .simultaneousGesture(
                    DragGesture()
                        .targetedToAnyEntity()
                        .onChanged { event in
                            if isAnnotationMode {
                                print("gesture blocked")
                            }else{
                                if let entity = selectedEntity {
                                    let delta = SIMD3<Float>(Float(event.translation.width) * 0.001,
                                                             0,
                                                             Float(event.translation.height) * -0.001)
                                    entity.transform.translation += delta
                                }
                            }
                        }
                        .onEnded { _ in print("Drag ended") }
                )

                // Tap Gesture
                .simultaneousGesture(
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
                )

                // Pinch (Zoom) Gesture added as a simultaneous gesture
                .simultaneousGesture(
                    MagnificationGesture()
                        .onChanged { value in
                            if isAnnotationMode {
                                print("gesture blocked")
                            }else{
                                if let entity = selectedEntity {
                                    // If an original transform exists, use it as the base scale
                                    if let orig = originalTransform {
                                        entity.transform.scale = orig.scale * Float(value)
                                    } else {
                                        entity.transform.scale *= Float(value)
                                    }
                                }
                            }
                        }
                        .onEnded { value in
                            if let entity = selectedEntity {
                                // Save the final transform for future pinch gestures
                                originalTransform = entity.transform
                            }
                        }
                )

                // Right-aligned Button Bar
                HStack {
                    Spacer().frame(width: 600)
                    VStack(spacing: 50) {
                        Button {
                            genderSelection.toggle()
                        } label: {
                            Image(systemName: "arrow.left.arrow.right")
                                .font(.title)
                        }

                        Button {
                            openWindow(id: "KnowledgeList")
                        } label: {
                            Image(systemName: "note.text")
                                .font(.title)
                        }

                        Button{
                            isAnnotationMode.toggle()
                        }label:{
                            Image(systemName: "list.bullet.clipboard")
                                .font(.title)
                        }

                        Button{
                            openWindow(id: "HelpWindow")
                        }label: {
                            Image(systemName: "questionmark.circle")
                                .font(.title)
                        }

                    }
                }
            }
        }
        .background(.clear)
    }
}


#Preview(windowStyle: .volumetric) {
    FemaleModelView()
        .volumeBaseplateVisibility( .visible)

}
