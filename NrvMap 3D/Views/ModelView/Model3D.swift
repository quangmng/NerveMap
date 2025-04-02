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

struct Model3DViewTest: View {
    
    @Environment(\.openImmersiveSpace) var scene
    @State private var selectedEntity: Entity?
    @StateObject var fvm = FunctionViewModel()
    @GestureState private var magnifyBy = 0.5
    
    var magnification: some Gesture {
        MagnifyGesture()
            .updating($magnifyBy) { value, gestureState, transaction in
                gestureState = value.magnification
            }
    }
    
    var body: some View {
        
        
        VStack {
            
            Model3D(named: "FemaleDModel") {
                model in model
                    .scaleEffect(magnifyBy)
                    .background(.clear)
                    .simultaneousGesture(
                        TapGesture()
                            .targetedToAnyEntity()
                            .onEnded { event in
                                selectedEntity = event.entity
                                fvm.highlightEntity(event.entity)
                            }
                    )
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
                    .scaleEffect(magnifyBy)
                    .gesture(magnification)
            }placeholder: {
                ProgressView()
            }
            
        }
    }
    
}

#Preview{
    Model3DViewTest()
}
