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
        sortDescriptors: [NSSortDescriptor(keyPath: \NoteEntity.dateCreated, ascending: false)],
        animation: .default
    ) var notes: FetchedResults<NoteEntity>
    
    @State var noteVM = NoteViewModel()

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
                        
                        if let position = noteVM.decodePosition(from: note){
                            Text("Position \(position.x), \(position.y), \(position.z)")
                                .font(.caption)
                        }
                        
                    }
                }
            }
            .navigationTitle("Saved Notes")
        }
    }
}
