//
//  NoteListView.swift
//  NrvMap 3D
//
//  Created by Wende Zhou on 4/4/2025.
//

import SwiftUI

struct NoteListView: View {
    @ObservedObject var noteVM: NoteViewModel
    var body: some View {
        List {
            ForEach(noteVM.notes) { note in
                Text(note.text)
            }
        }
    }
}
