//
//  NoteListView.swift
//  NrvMap 3D
//
//  Created by Wende Zhou on 4/4/2025.
//

import SwiftUI
import SwiftData

struct NoteListView: View {

    @Environment(\.modelContext) private var context
    @Query(sort: \NoteData.dateCreated, order: .reverse) private var notes: [NoteData]

    var body: some View {
        NavigationStack {
            List {
                ForEach(notes) { note in
                    NoteRowView(note: note)
                }
            }
            .navigationTitle("Saved Notes")
        }
    }
}
