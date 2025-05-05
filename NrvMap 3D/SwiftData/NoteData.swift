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
  @Attribute(.unique) var id: String
  var title: String
  var details: String
  var dateCreated: Date

  init(id: String, title: String, details: String, dateCreated: Date) {
    self.id = id
    self.title = title
    self.details = details
    self.dateCreated = dateCreated
  }
}
