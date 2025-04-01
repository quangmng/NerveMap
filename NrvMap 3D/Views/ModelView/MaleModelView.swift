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
    
    @State private var angle = Angle(degrees: 0.0)
    @GestureState private var magnifyBy = 1.0
    @State private var modelEntity: Entity?
    @State private var selectedEntity: Entity?
    @State private var originalTransform: Transform?
    @State private var isAnnotationMode = false
    @StateObject var fvm = FunctionViewModel()
    @State private var isOr = true
    
    var magnification: some Gesture {
            MagnifyGesture()
                .updating($magnifyBy) { value, gestureState, transaction in
                    gestureState = value.magnification
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
                
                RealityView{ content in
                    
                    do {
                        let entity = try await Entity.load(named: "FemaleDModel")
                        
                        entity.scale = SIMD3<Float>(0.5, 0.5, 0.5)
                        entity.generateCollisionShapes(recursive: true)
                        entity.position = SIMD3<Float>(0, -0.5, 0)
                        fvm.enableInteraction(for: entity)
                        content.add(entity)
                        modelEntity = entity
                        originalTransform = entity.transform
                        
                        if isOr == true{
                            print("ok")
                        }else{
                            entity.position = SIMD3<Float>(0, -0.5, 0)
                        }
                        
                    } catch {
                        print("Failed to load model: \(error)")
                    }
                    
                }
                .rotationEffect(angle)
                .gesture(rotation)
                .scaleEffect(magnifyBy)
                .simultaneousGesture(magnification)
                .simultaneousGesture(
                    DragGesture()
                        .targetedToAnyEntity()
                        .onChanged { event in
                            if isAnnotationMode {
                                print("gesture blocked")
                            }else{
                                if let entity = selectedEntity {
                                    let delta = SIMD3<Float>(Float(event.translation.width) * 0.001, 0, Float(event.translation.height) * -0.001)
                                    entity.transform.translation += delta
                                }
                            }
                        }
                        .onEnded { _ in print("Drag ended") }
                )
                .gesture(
                    TapGesture()
                        .targetedToAnyEntity()
                        .onEnded { event in
                            selectedEntity = event.entity
                            fvm.highlightEntity(event.entity)
                        }
                )
                .scaleEffect(magnifyBy)
                .gesture(magnification)
                HStack {
                    Spacer().frame(width: 600)
                    VStack {
                        Button {
                            isOr.toggle()
                            print(isOr)
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
            if isOr == true{
                Color.gray
            }
            else {
                Color.clear
            }
        }
    }
}


#Preview(windowStyle: .volumetric) {
    MaleModelView()
        .volumeBaseplateVisibility( .visible)
        
}
