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
    @EnvironmentObject var fvm: FunctionViewModel
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \NoteData.dateCreated, order: .forward) private var notes: [NoteData]

    var body: some View {
        VStack(spacing: 16) {
            Text("Add Note").font(.headline)
            Text("Currenly in \(fvm.position) ")
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
            dateCreated: Date(),
            // TODO: solve the position info in the array or swiftdata
            // MARK: - Codes added
            position: fvm.position
        )
        modelContext.insert(newNote)
        do {
            try modelContext.save()
        } catch {
            print("Error saving note: \(error)")
        }
        // Close the annotation window
        dismissWindow(id: "AnnotationWindow")
    }
}
