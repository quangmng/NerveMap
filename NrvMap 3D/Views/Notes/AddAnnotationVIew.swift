//
//  AddAnnotationVIew.swift
//  NrvMap 3D
//
//  Created by Ian So on 10/4/2025.
//

import SwiftUI
import SwiftData
import RealityKit
import RealityKitContent

struct AddAnnotationVIew: View {

    @Environment(\.dismissWindow) private var dismissWindow
    @State private var title = ""
    @State private var content = ""

    @Environment(\.modelContext) private var context
//    @Query private var notes: [NoteData]

    var position: SIMD3<Float>

    var body: some View {
        VStack(spacing: 16) {
            Text("Add Note").font(.headline)
            TextField("Title", text: $title)
            TextField("Description", text: $content)
            Button("Save") {
                saveNote()
            }

            Button("Cancel") {
                dismissWindow(id: "AnnotationWindow")
            }
        }
        .frame(width: 300)
        .padding()
    }

    func saveNote() {
        // Create and insert the new model
        let newNote = NoteData(
            id: UUID().uuidString,
            title: title,
            details: content,
            position: position,
            dateCreated: Date()
        )
        context.insert(newNote)
        do {
            try context.save()
        } catch {
            print("Error saving note: \(error)")
        }
        // Close the annotation window
        dismissWindow(id: "AnnotationWindow")
    }
}
