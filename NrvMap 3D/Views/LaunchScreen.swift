//
//  LaunchScreen.swift
//  NrvMap 3D
//
//  Created by Ian So on 17/4/2025.
//

import SwiftUI

struct InitialLauncherView: View {
    @Environment(\.openWindow) public var open
    @Environment(\.dismissWindow) private var dismiss
    var body: some View {
        
        EmptyView()
        .task {
            try? await Task.sleep(nanoseconds: 1_000_000_000) // Optional delay
            await open(id: "WelcomeView")
            dismiss(id: "launch")
        }
    }
}
