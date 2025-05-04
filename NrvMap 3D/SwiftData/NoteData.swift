//
//  NoteData.swift
//  NrvMap 3D
//
//  Created by Wendy Zhou on 4/5/2025.
//

import Foundation
import SwiftData
import simd

@Model
class NoteData: Identifiable {
    var id: String
    var title: String
    var details: String
    var position: SIMD3<Float>
    var dateCreated: Date

    init(
        id: String,
        title: String,
        details: String,
        position: SIMD3<Float>,
        dateCreated: Date
    ) {
        self.id = id
        self.title = title
        self.details = details
        self.position = position
        self.dateCreated = dateCreated
    }
}
