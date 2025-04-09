//
//  NoteRowView.swift
//  NrvMap 3D
//
//  Created by Quang Minh Nguyen on 4/4/25.
//

import SwiftUI

struct NoteRowView: View {
    
    let note: Note
    
    var body: some View {
        VStack {
            let dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                return formatter
            }()
            Text(note.text)
            Text(dateFormatter.string(from: note.dateCreated))
        }
    }
}
