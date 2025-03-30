//
//  AnnotationModel.swift
//  NrvMap 3D
//
//  Created by Ian So on 30/3/2025.
//

import Foundation
import SwiftUI

struct Annotation: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var position: SIMD3<Float>
}
