//
//  ImmersiveTest.swift
//  NrvMap 3D
//
//  Created by Ian So on 1/4/2025.
//

import RealityKit
import SwiftUI

struct ImmersiveControl: View {
    
    // Default as walking
//    @State private var pose: ModelGesture = .walking    
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @State private var isImmersive: Bool = false
    @EnvironmentObject var fvm: FunctionViewModel
    
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
        
        Button{
            fvm.playAnimation()
        }label:{
            Text("Start Animation")
                .font(.extraLargeTitle)
        }
        
        Button{
            fvm.stopAnimation()
        }label:{
            Text("Stop Animation")
                .font(.extraLargeTitle)
        }
        
        Button {
            
        } label: {
            
        }

        
        
    }
}

#Preview{
    ImmersiveControl()
}
