//
//  NoteListView.swift
//  NrvMap 3D
//
//  Created by Wende Zhou on 4/4/2025.
//

import SwiftUI
import CoreData

struct NoteListView: View {
    @FetchRequest(
        entity: NoteEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \NoteEntity.dateCreated, ascending: false)]
    ) var notes: FetchedResults<NoteEntity>

    var body: some View {
        NavigationStack {
            List {
                ForEach(notes) { note in
                    VStack(alignment: .leading) {
                        Text(note.title ?? "No text")
                            .font(.headline)
                        Text(note.dateCreated!, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Saved Notes")
        }
    }
}
