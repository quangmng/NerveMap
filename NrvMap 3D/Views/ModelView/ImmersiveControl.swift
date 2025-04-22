//
//  ImmersiveTest.swift
//  NrvMap 3D
//
//  Created by Ian So on 1/4/2025.
//

import RealityKit
import SwiftUI

struct ImmersiveControl: View {
    
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @State private var isImmersive: Bool = false
    
    var body: some View {
        Button{
            Task {
                if isImmersive == false {
                    await openImmersiveSpace(id: "Immersive")
                    isImmersive = true
                    dismissWindow(id: "WelcomeView")
                    
                } else {
                    await dismissImmersiveSpace()
                    isImmersive = false
                    openWindow(id: "WelcomeView")
                }
            }
        }label:{
            if isImmersive == false{
                Text("View 3D Model")
                    .font(.extraLargeTitle)
            }else{
                Text("Exit Immsersive Space")
                    .font(.extraLargeTitle)
            }
        }
    }
}
