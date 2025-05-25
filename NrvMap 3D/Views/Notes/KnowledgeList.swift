//
//  KnowledgeList.swift
//  NrvMap 3D
//
//  Created by Wendy Zhou on 10/4/2025.
//

import SwiftUI

struct KnowledgeList: View {
    var body: some View {
        List(allDermatomes) { derm in
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(colorForFirstCharacter(of: derm.nerveLevel))
                    .frame(width: 100, height: 100)
                    .overlay {
                        Text(derm.nerveLevel)
                            .font(.system(size: 45, weight: .bold))
                            .foregroundColor(.white)
                    }

                Spacer().frame(width: 20)

                VStack(alignment: .leading) {
                    Text(derm.area)
                        .font(.system(size: 35, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(derm.clinicalNote)
                        .font(.system(size: 30, weight: .regular))
                        .foregroundColor(.primary)
                        .lineLimit(3)  // Limit the clinical note lines to make it cleaner
                        .truncationMode(.tail)  // Truncate long text
                }
            }
        }
        .listStyle(.inset)
    }

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
}

#Preview {
    KnowledgeList()
}

