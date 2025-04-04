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
    
    func addNote(text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
            let newNote = Note(text: text)
            notes.append(newNote)
        }
}
