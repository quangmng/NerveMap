//
//  NoteListView.swift
//  NrvMap 3D
//
//  Created by Wende Zhou on 4/4/2025.
//

import SwiftUI
import SwiftData

struct NoteListView: View {

    @Query(sort: \NoteData.dateCreated, order: .reverse) private var notes: [NoteData]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(notes, id: \.id) { note in
                    NoteRowView(note: note)
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Saved Notes")
                        .font(.system(size: 50, weight: .black))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .buttonBorderShape(.circle)



                }
            })
        }
    }
}

#Preview {
    let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: NoteData.self, configurations: modelConfiguration)

    // Add mock notes for preview
    let context = container.mainContext
    let sampleNotes = [
        NoteData(id: UUID().uuidString, title: "Covers the inner (medial) part of the forearm and arm near the elbow", details: "Important in brachial plexus injuries, especially lower plexus injuries (C8-T1)", dateCreated: Date(), position: "T1"),
        NoteData(id: UUID().uuidString, title: "Covers the back of the head and upper neck", details: "Common in occipital neuralgia, where pain radiates from the base of the skull.", dateCreated: Date().addingTimeInterval(-3600), position: "C2")
    ]
    sampleNotes.forEach { context.insert($0) }

    return NoteListView()
        .modelContainer(container)
}
