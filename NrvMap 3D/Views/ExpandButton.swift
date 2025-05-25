//
//  ExpandButton.swift
//  NrvMap 3D
//
//  Created by Ian So on 21/4/2025.
//

import Foundation
import SwiftUI

// a view with action and label -> button

struct ExpandButton: View {
    let id: Int
    let systemImage: String
    let action: () -> Void
    let extraButtons: [(String, () -> Void)]

    @Binding var expandButton: Int?

    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                if expandButton == id {
                    expandButton = nil
                } else {
                    expandButton = id
                }
                action()
            }) {
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
            .frame(width: 80, height: 80)


            if expandButton == id {
                
                ForEach(0..<extraButtons.count, id: \.self) { index in
                    Button(action: extraButtons[index].1) {
                        Image(systemName: extraButtons[index].0)
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }
                    .transition(.opacity)
                    .frame(width: 60, height: 60)
                }
            }
        }
        .animation(.spring(), value: expandButton)
    }
}
