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
    
    @State var im = ImmersiveView()
    @EnvironmentObject var fvm: FunctionViewModel
    
    var body: some View {
        
        HStack{
            Button{
                Task {
                    if isImmersive == false {
                        fvm.style = .mixed
                        fvm.isMix = true
                        await dismissImmersiveSpace()
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
                    Text("Enter Mix Reality")
                        .font(.extraLargeTitle)
                }else{
                    Text("Exit Immsersive Space")
                        .font(.extraLargeTitle)
                }
            }
            
            Button{
                Task {
                    if isImmersive == false {
                        fvm.style = .full
                        fvm.isMix = false
                        await dismissImmersiveSpace()
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
                    Text("Enter Full Reality")
                        .font(.extraLargeTitle)
                }else{
                    Text("Exit Immsersive Space")
                        .font(.extraLargeTitle)
                }
            }
            
        }
    }
}

#Preview{
    ImmersiveControl()
}
