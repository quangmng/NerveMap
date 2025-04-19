//
//  NoteViewModel.swift
//  NrvMap 3D
//
//  Created by Wende Zhou on 4/4/2025.
//

import Foundation
import Combine


class NoteViewModel: ObservableObject {
    @Published var notes: [Note] = []
    var pendingLocation: SIMD3<Float>? = nil
    
    func addNote(title: String, content: String, position: SIMD3<Float>, date: Date) {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let newNote = Note(title: title, content: content, position: position, dateCreated: date)
            notes.append(newNote)
        }
}
