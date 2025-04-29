//
//  NoteListView.swift
//  NrvMap 3D
//
//  Created by Wende Zhou on 4/4/2025.
//

/*
 if let position = noteVM.decodePosition(from: note){
     Text("Position \(position.x), \(position.y), \(position.z)")
         .font(.caption)
 }
 */

import SwiftUI
import CoreData

struct NoteListView: View {
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \NoteEntity.dateCreated, ascending: false)],
//        animation: .default
//    ) var notes: FetchedResults<NoteEntity>
    
    @EnvironmentObject var noteVM: NoteViewModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(noteVM.notes, id: \.self) { note in
                    NoteRowView(note: note)
                }
            }
            .navigationTitle("Saved Notes")
        }
    }
}
