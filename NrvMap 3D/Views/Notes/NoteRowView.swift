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

        HStack(spacing: 0) {
            noteComponent

            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.orange )
                .frame(width: 260, height: 100)
                .overlay {
                    Text(Self.dateFormatter.string(from: note.dateCreated))
                        .font(.system(size: 40, weight: .bold))
                }
                .traling()
        }
    }
}

#Preview {
    NoteRowView(note: NoteData(
        id: UUID().uuidString,
        title: "Sample Note",
        details: "This is a preview of a note with position info.",
        dateCreated: Date(),
        position: "T1"
    ))
}

extension NoteRowView {
    private var noteComponent: some View {
        VStack(alignment: .leading, spacing: 25) {
            HStack(spacing: 20) {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(Color.green)
                    .frame(width: 100, height: 100)
                    .overlay {
                        Text(note.position)
                            .font(.system(size: 60, weight: .heavy))
                    }


                Text(note.title)
                    .font(.system(size: 50))
                    .underline()
//                    .lineLimit(5)
            }

            Text(note.details)
                .font(.system(size: 40))
        }
    }
}
