//
//  NoteRowView.swift
//  NrvMap 3D
//
//  Created by Quang Minh Nguyen on 4/4/25.
//

import SwiftUI
import SwiftData

struct NoteRowView: View {

    let note: NoteData

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()

    var body: some View {
        VStack {
            Text(note.title)
            Text(note.details)
            Text(Self.dateFormatter.string(from: note.dateCreated))
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
