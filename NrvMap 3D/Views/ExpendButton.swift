//
//  HoverButton.swift
//  NrvMap 3D
//
//  Created by Ian So on 21/4/2025.
//

import Foundation
import SwiftUI

struct ExpendButton: View {
    let id: Int
    let systemImage: String
    let action: () -> Void
    let extraButtons: [(String, () -> Void)]

    @Binding var expendButton: Int?

    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                if expendButton == id {
                    expendButton = nil
                } else {
                    expendButton = id
                }
                action()
            }) {
                Image(systemName: systemImage)
                    .font(.largeTitle)
            }

            if expendButton == id {
                ForEach(0..<extraButtons.count, id: \.self) { index in
                    Button(action: extraButtons[index].1) {
                        Image(systemName: extraButtons[index].0)
                            .font(.title2)
                    }
                    .transition(.opacity)
                }
            }
        }
        .animation(.easeInOut, value: expendButton)
    }
}
