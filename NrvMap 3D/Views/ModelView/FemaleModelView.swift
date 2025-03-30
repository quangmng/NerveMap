//
//  ModelView.swift
//  NrvMap 3D
//
//  Created by Ian So on 25/3/2025.
//

import SwiftUI
import RealityKit

struct FemaleModelView: View {
    
    @State private var modelEntity: Entity?
    @State private var selectedEntity: Entity?
    @State private var originalTransform: Transform?
    @StateObject var fvm = FunctionViewModel()
    
    var body: some View {
        HStack {
            ZStack {
                RealityView { content in
                    do {
                        let entity = try await Entity.load(named: "FemaleDModel")
                        entity.scale = SIMD3<Float>(0.5, 0.5, 0.5)
                        entity.generateCollisionShapes(recursive: true) // Enable tap & drag
                        entity.position = SIMD3<Float>(0, -0.5, 0)
                        
                        fvm.enableInteraction(for: entity)
                        content.add(entity)
                        
                        modelEntity = entity
                        originalTransform = entity.transform // Save original position
                    } catch {
                        print("Failed to load model: \(error)")
                    }
                }
                // **Add Drag & Tap Gestures for Interaction**
                .gesture(
                    DragGesture()
                        .targetedToAnyEntity()
                        .onChanged { event in
                            if let entity = selectedEntity {
                                let delta = SIMD3<Float>(Float(event.translation.width) * 0.001, 0, Float(event.translation.height) * -0.001)
                                entity.transform.translation += delta
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
                
                
                // **Right-aligned Button Bar**
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
                            print("Favorite tapped")
                        } label: {
                            Image(systemName: "heart.text.clipboard")
                        }
                        .frame(width: 50, height: 50)
                        .padding()
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
