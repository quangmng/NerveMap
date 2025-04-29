//
//  NoteRowView.swift
//  NrvMap 3D
//
//  Created by Quang Minh Nguyen on 4/4/25.
//

import SwiftUI
import CoreData

struct NoteRowView: View {
    
    let note: NoteEntity
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    var body: some View {
        VStack {
            Text(note.title ?? "Untitled")
            if let date = note.dateCreated {
                Text(Self.dateFormatter.string(from: date))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}
