//
//  HoverButton2.swift
//  NrvMap 3D
//
//  Created by Ian So on 21/4/2025.
//

import SwiftUI

struct HoverRevealButton: View {
    let mainIcon: String
    let mainAction: () -> Void
    let extraButtons: [(icon: String, action: () -> Void)]

    @State private var isHovering = false

    var body: some View {
        HStack(spacing: 12) {
            // Main button
            Button(action: mainAction) {
                Image(systemName: mainIcon)
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
            }
            .onContinuousHover { phase in
                if case .active = phase {
                    withAnimation(.easeInOut) {
                        isHovering = true
                    }
                } else {
                    withAnimation(.easeInOut) {
                        isHovering = false
                    }
                }
            }

            // Extra buttons shown on hover
            if isHovering {
                ForEach(0..<extraButtons.count, id: \.self) { index in
                    let extra = extraButtons[index]
                    Button(action: extra.action) {
                        Image(systemName: extra.icon)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}
