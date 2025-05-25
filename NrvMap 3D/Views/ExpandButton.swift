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
    let extraButtons: [(systemImage: String, action: () -> Void, helpText: String)]

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
                
                ForEach(extraButtons, id: \.systemImage) { systemImage, action, helpText in
                    Button(action: action) {
                        Image(systemName: systemImage)
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }
                    .help(helpText)
                    .transition(.opacity)
                    .frame(width: 60, height: 60)
                }
            }
        }
        .animation(.spring(), value: expandButton)
    }
}
