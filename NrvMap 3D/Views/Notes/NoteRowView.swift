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

    func colorForFirstCharacter(of text: String) -> Color {
        guard let firstChar = text.first else {
            return .gray // Default color for empty input
        }

        switch firstChar.uppercased() {
        case "C":
            return .orange
        case "T":
            return .green
        case "L":
            return .blue
        case "S":
            return .purple
        default:
            return .gray
        }
    }

    var body: some View {

        HStack(spacing: 0) {

                HStack(spacing: 20) {
                    RoundedRectangle(cornerRadius: 20)
                    
                        .fill(colorForFirstCharacter(of: note.position))
                        .frame(width: 180, height: 180)
                        .overlay {
                            Text(note.position)
                                .font(
                                    .system(
                                        size: 80,
                                        weight: .bold,
                                        design: .rounded
                                    )
                                )
                        }

                    VStack(alignment: .leading, spacing: 25) {
                        Text(note.title)
                            .font(
                                .system(
                                    size: 70,
                                    weight: .semibold,
                                    design: .rounded
                                )
                            )
                            .underline()

                        Text(note.details)
                            .font(
                                .system(
                                    size: 60,
                                    weight: .regular,
                                    design: .rounded
                                )
                            )
                    }
                }

            Spacer()

            // MARK: -Date component
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.gray.opacity(0.8))
                .frame(width: 260, height: 100)
                .overlay {
                    Text(Self.dateFormatter.string(from: note.dateCreated))
                        .font(
                            .system(size: 40, weight: .bold, design: .rounded)
                        )
                }

        }
    }
}

#Preview {
    NoteRowView(note: NoteData(
        id: UUID().uuidString,
        title: "Sample Note",
        details: "This is a preview of a note with position info.",
        dateCreated: Date(),
        position: "S1"
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
