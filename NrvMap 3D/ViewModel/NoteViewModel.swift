//
//  NoteViewModel.swift
//  NrvMap 3D
//
//  Created by Wende Zhou on 4/4/2025.
//

import SwiftUI
import CoreData

class NoteViewModel: ObservableObject {
    @Published var notes: [NoteEntity] = []
    var pendingLocation: SIMD3<Float>? = nil

    let context = PersistenceController.shared.container.viewContext // adjust as needed

    func addNote(title: String, content: String, position: SIMD3<Float>, date: Date) {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let newNote = NoteEntity(context: context)
        newNote.title = title
        newNote.details = content
        newNote.dateCreated = date
        newNote.id = UUID()
        newNote.position = position.x

        do {
            try context.save()
            notes.append(newNote)
        } catch {
            print("❌ Failed to save note: \(error.localizedDescription)")
        }
    }
}
