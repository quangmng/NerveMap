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
    @State private var modelEntity: Entity? = nil
    @State private var selectedEntity: Entity?
    @State private var originalTransform: Transform?
    @State private var isAnnotationMode = false
    @StateObject var fvm = FunctionViewModel()
    @State var initialScale: SIMD3<Float>? = nil
    @Environment(AnnotationViewModel.self) private var avm
    @State private var AnnotationAnchor = AnchorEntity()
    @State private var genderSelect: Bool = false
    
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
    
                        let entity = await fvm.create3DModel()
                        entity.scale = SIMD3<Float>(0.5, 0.5, 0.5)
                        entity.position = SIMD3<Float>(0, -0.5, 0)
                        AnnotationAnchor.position = [0, -0.9, 0]
                        entity.addChild(AnnotationAnchor)
                        fvm.enableInteraction(for: entity)
                        content.add(entity)
                        modelEntity = entity
                        originalTransform = entity.transform
                    
                    
                    
                }update:{content, attachments in
                
                    if (genderSelect){
                        if let modelEntity{
                            content.add(modelEntity)
                        }
                    }
                    else{
                        if let modelEntity {
                            content.remove(modelEntity)
                            }
                    }
                    
                    for list in avm.annotationList {
                        if let listEntity = attachments.entity(for: list.id){
                            content.add(listEntity)
                           
                       }
                    }
                    if let entity = content.entities.first(where: { $0.name == "MainModel" }) {
                        entity.move(to: Transform(translation: [0, 0.3, -1.2]), relativeTo: nil, duration: 5.0)
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
               
//Gesture
                
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
                            genderSelect.toggle( )
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
