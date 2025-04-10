//
//  AnnotationViewModel.swift
//  NrvMap 3D
//
//  Created by Ian So on 10/4/2025.
//

import Foundation

@Observable
class AnnotationViewModel {
    var annotationList: [AnnotationModel] = []
    var pendingLocation: SIMD3<Float>? = nil
}
