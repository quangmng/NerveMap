//
//  InfoView.swift
//  NrvMap 3D
//
//  Created by Ian So on 20/5/2025.
//

import SwiftUI

struct InfoView: View {
    
    @State var name: String

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
        if let selectedArea = allDermatomes.first(where: { $0.nerveLevel == name.uppercased() }){
            NavigationStack {
                    HStack {

                        RoundedRectangle(cornerRadius: 20)
                            .fill(colorForFirstCharacter(of: selectedArea.nerveLevel))
                            .frame(width: 180, height: 180)
                            .overlay {
                                Text("\(selectedArea.nerveLevel)")
                                    .font(
                                        .system(
                                            size: 80,
                                            weight: .bold,
                                            design: .rounded
                                        )
                                    )
                            }
                        VStack(alignment: .leading) {
                            Text("\(selectedArea.area)")
                                .font(
                                    .system(
                                        size: 50,
                                        weight: .bold,
                                        design: .rounded
                                    )
                                )
                            Text("\(selectedArea.clinicalNote)")
                                .font(
                                    .system(
                                        size: 40,
                                        weight: .regular,
                                        design: .rounded
                                    )
                                )
                        }
                    }
                    .navigationTitle("Dermatome Level")

//                        Text("In Case of Herniated Disc (L4-L5)")
//                            .font(
//                                .system(
//                                    size: 60,
//                                    weight: .semibold,
//                                    design: .rounded
//                                )
//                            )
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(name: "C4")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

