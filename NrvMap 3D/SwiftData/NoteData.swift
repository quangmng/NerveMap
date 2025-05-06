//
//  NoteData.swift
//  NrvMap 3D
//
//  Created by Wendy Zhou on 4/5/2025.
//

import Foundation
import SwiftData

@Model
final class NoteData {
  var id = UUID().uuidString
  var title: String
  var details: String
  var dateCreated: Date
  var position: String

  init(id: String, title: String, details: String, dateCreated: Date, position: String) {
    self.id = id
    self.title = title
    self.details = details
    self.dateCreated = dateCreated
    self.position = position
  }
}
