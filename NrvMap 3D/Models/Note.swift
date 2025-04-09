//
//  Note.swift
//  NrvMap 3D
//
//  Created by Wende Zhou on 4/4/2025.
//

import Foundation

struct Note: Identifiable {
    let id = UUID().uuidString
    var text: String
    var dateCreated: Date = Date()
}
