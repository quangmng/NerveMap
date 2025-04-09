//
//  SIMD3.swift
//  NrvMap 3D
//
//  Created by Ian So on 4/4/2025.
//

import SwiftUI

/// The extension of `SIMD3` where the scalar is a float.
extension SIMD3 where Scalar == Float {
    /// The variable to lock the y-axis value to 0.
    var grounded: SIMD3<Scalar> {
        return .init(x: x, y: 0, z: z)
    }
}
