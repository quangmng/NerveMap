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

    @Binding var expendButton: Int?

    var body: some View {
        HStack(spacing: 8) {
//            Button {
//                if expendButton == id {
//                    expendButton = nil
//                } else {
//                    expendButton = id
//                }
//                action()
//            } label: {
//                Image(systemName: systemImage)
//                    .font(.largeTitle)
//                    .frame(width: 50, height: 50)
//            }

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
                    .frame(width: 50, height: 50)
            }
            .background {
                Circle()
            }

            if expendButton == id {
                ForEach(0..<extraButtons.count, id: \.self) { index in
                    Button(action: extraButtons[index].1) {
                        Image(systemName: extraButtons[index].0)
                            .font(.largeTitle)
                            .frame(width: 50, height: 50)
                    }
                    .transition(.opacity)
                }
            }
        }
        .animation(.spring(), value: expendButton)
    }
}
