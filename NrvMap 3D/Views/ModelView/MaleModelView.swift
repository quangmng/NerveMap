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
    @State private var modelEntity: Entity?
    @State private var selectedEntity: Entity?
    @State private var originalTransform: Transform?
    @State private var isAnnotationMode = false
    @StateObject var fvm = FunctionViewModel()
    @State var initialScale: SIMD3<Float>? = nil
    @State var annotationList: [AnnotationModel] = [AnnotationModel(title: "Hello1", description: "Try to test", position: SIMD3<Float>(-1, -1, -1)),AnnotationModel(title: "Hello2", description: "Try to test", position: SIMD3<Float>(-3, -3, -3))]
    
    var tap: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { event in
                selectedEntity = event.entity
                fvm.highlightEntity(event.entity)
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
                        let delta = SIMD3<Float>(Float(event.translation.width) * -0.0001, 0, Float(event.translation.height) * -0.0001)
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
                let rootEntity = value.entity
                if initialScale == nil {
                    initialScale = rootEntity.scale
                }
                let scaleRate: Float = 1.0
                rootEntity.scale = (initialScale ?? .init(repeating: scaleRate)) * Float(value.gestureValue.magnification)
            }
            .onEnded { _ in
                initialScale = nil
            }
    }
    
    var rotation: some Gesture {
           RotateGesture()
               .onChanged { value in
                   angle = value.rotation
               }
       }
    
    var body: some View {
        
        HStack {
            ZStack {
               
//3D model generation
                RealityView{ content, attachments in
    
                        let entity = await fvm.create3DModel()
                        entity.scale = SIMD3<Float>(0.5, 0.5, 0.5)
                        entity.position = SIMD3<Float>(0, -0.5, 0)
                        fvm.enableInteraction(for: entity)
                        content.add(entity)
                        modelEntity = entity
                        originalTransform = entity.transform
                    
                }update:{content, attachments in
                
                   for list in annotationList {
                        if let listEntity = attachments.entity(for: list.id){
                            content.add(listEntity)
                           
                       }
                    }
                    
                }
                attachments: {
                    ForEach(annotationList) { list in
                        Attachment(id: list.id) {
                            Button("\(list.title)"){
                                openWindow(id: "ModelDM")
                            }
                        }
                    }
                }
               
//Gesture
                .simultaneousGesture(rotation)
                .simultaneousGesture(scaleGesture)
                .simultaneousGesture(drag)
                .simultaneousGesture(tap)
                
                HStack {
                    Spacer().frame(width: 600)
                    VStack {
                        Button {
                           
                        } label: {
                            Image(systemName: "house")
                        }
                        .frame(width: 50, height: 50)
                        .padding()
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "square.resize")
                        }
                        .frame(width: 50, height: 50)
                        .padding()
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "move.3d")
                        }
                        .frame(width: 50, height: 50)
                        .padding()
                        
                        Button {
                            isAnnotationMode.toggle()
                            print(isAnnotationMode)
                        } label: {
                            Image(systemName: "heart.text.clipboard")
                        }
                        .frame(width: 50, height: 50)
                        .padding()
                    }
                    .background(Color.gray.cornerRadius(30))
                }
            }
        }.background{
            if isAnnotationMode == true {
                Color.black.opacity(0.5)
            }
        }
    }
}


#Preview(windowStyle: .volumetric) {
    MaleModelView()
        .volumeBaseplateVisibility( .visible)
        
}
