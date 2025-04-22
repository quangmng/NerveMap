//
//  NoteModel.swift
//  NrvMap 3D
//
//  Created by Wende Zhou on 4/4/2025.
//

import Foundation

struct NoteModel: Identifiable {
    let id: UUID
    var title: String?
    var details: String?
    var position: SIMD3<Float>
    var dateCreated: Date?
}
