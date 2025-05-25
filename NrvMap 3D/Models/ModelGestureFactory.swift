//
//  ModelGestureFactory.swift
//  NrvMap 3D
//
//  Created by Wendy Zhou on 6/5/2025.
//


// ModelGestureFactory.swift

import SwiftUI
import RealityKit

/// A namespace for building gestures — everything is passed in as arguments,
/// so this file has no `@EnvironmentObject` itself.
enum ModelGestureFactory {
    
    static func tapGesture(
        fvm: FunctionViewModel,
        selectedEntity: Binding<Entity?>,
        openWindow: @escaping (String) -> Void
    ) -> some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { event in
                guard !fvm.isAnnotationMode else {
                    openWindow("AnnotationWindow")
                    fvm.position = event.entity.name
                    return
                }
                selectedEntity.wrappedValue = event.entity
                fvm.highlightEntity(event.entity)
                fvm.position = event.entity.name
                fvm.simdPosition = event.entity.position
            }
    }
    
    static func dragGesture(
        fvm: FunctionViewModel,
        selectedEntity: Binding<Entity?>
    ) -> some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { event in
                guard !fvm.isAnnotationMode,
                      let entity = selectedEntity.wrappedValue
                else {
                    print("gesture blocked")
                    return
                }
                let delta = SIMD3<Float>(
                    Float(event.translation.width) * 0.0001,
                    0,
                    Float(event.translation.height) * -0.0001
                )
                entity.transform.translation += delta
            }
            .onEnded { _ in print("Drag ended") }
    }
    
    static func scaleGesture(
        fvm: FunctionViewModel,
        initialScale: Binding<SIMD3<Float>?>
    ) -> some Gesture {
        MagnifyGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                guard !fvm.isAnnotationMode else {
                    print("gesture blocked")
                    return
                }
                let root = value.entity
                if initialScale.wrappedValue == nil {
                    initialScale.wrappedValue = root.scale
                }
                root.scale = (initialScale.wrappedValue ?? .init(repeating: 1.0))
                * Float(value.gestureValue.magnification)
            }
            .onEnded { _ in initialScale.wrappedValue = nil }
    }
    
    static func rotationGesture(
        fvm: FunctionViewModel,
        angle: Binding<Angle>
    ) -> some Gesture {
        RotateGesture()
            .onChanged { value in
                guard !fvm.isAnnotationMode else {
                    print("gesture blocked")
                    return
                }
                angle.wrappedValue = value.rotation
            }
    }
}
