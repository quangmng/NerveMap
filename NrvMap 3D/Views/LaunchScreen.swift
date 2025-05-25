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
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @AppStorage("hasSeenWelcomeScreen") var hasSeenWelcomeScreen = false
    @State var isVisable: Bool = true
    
    var body: some View {
        VStack{
            
        }
        
        .task {
            Task {
                if hasSeenWelcomeScreen == true{
                    
                    try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
                    //                    await open(id: "WelcomeView")
                    open(id: "WelcomeView")
                    dismiss(id: "launch")
                    isVisable = false
                }else{
                    try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
                    //                    await open(id: "WelcomeView")
                    open(id: "HelpWindow")
                    dismiss(id: "launch")
                    isVisable = false
                }
            }
        }
    }
}
