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
    @EnvironmentObject var fvm: FunctionViewModel
    
    @State private var fullImmersive: Bool = false
    @State private var mixImmersive: Bool = false
    
    var body: some View {
        
        HStack{
            Button{
                Task {
                    if fvm.isImmersive == false {
                        fvm.style = .mixed
                        fvm.isMix = true
                        await openImmersiveSpace(id: "Immersive")
                        fvm.isImmersive = true
                        dismissWindow(id: "WelcomeView")
                        
                    } else {
                        await dismissImmersiveSpace()
                        fvm.isImmersive = false
                        openWindow(id: "WelcomeView")
                        fvm.isMix = false
                    }
                }
            }label:{
                if fvm.isImmersive == false{
                    Text("Enter Mix Reality")
                        .font(.extraLargeTitle)
                }else{
                    Text("Exit Immsersive Space")
                        .font(.extraLargeTitle)
                }
            }.disabled(fvm.isFull == true)
            
            Button{
                Task {
                    if fvm.isImmersive == false {
                        fvm.style = .full
                        fvm.isFull = true
                        await openImmersiveSpace(id: "Immersive")
                        fvm.isImmersive = true
                        dismissWindow(id: "WelcomeView")
                        
                    } else {
                        await dismissImmersiveSpace()
                        fvm.isImmersive = false
                        openWindow(id: "WelcomeView")
                        fvm.isFull = false
                    }
                }
            }label:{
                if fvm.isImmersive == false{
                    Text("Enter Full Reality")
                        .font(.extraLargeTitle)
                }else{
                    Text("Exit Immsersive Space")
                        .font(.extraLargeTitle)
                }
            }.disabled(fvm.isMix == true)
            
        }
    }
}

#Preview{
    ImmersiveControl()
}
