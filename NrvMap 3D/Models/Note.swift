//
//  Note.swift
//  NrvMap 3D
//
//  Created by Wende Zhou on 4/4/2025.
//

import Foundation

struct Note: Identifiable {
    let id = UUID()
    var title: String
    var content: String
    var position: SIMD3<Float>
    var dateCreated: Date = Date()
}
