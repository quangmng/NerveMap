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
        VStack{
            Text("Environment")
                .font(.extraLargeTitle)
                .bold()
                .padding()
                .leading()
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
                            dismissWindow(id: "BtnBoard")
                            dismissWindow(id: "Control")
                            fvm.isMix = false
                        }
                    }
                }label:{
                    if fvm.isImmersive == false{
                        VStack{
                            Text("👁️")
                                .center()
                            Text("Real-Life")
                                .font(.title)
                                .center()
                        }
                    }else{
                        Text("Exit Immsersive Space")
                            .font(.extraLargeTitle)
                    }
                }.frame(width: 225, height: 100)
                    .background(Color.gray)
                    .cornerRadius(25)
                    .buttonStyle(.plain)
                    .disabled(fvm.isMix == true)
                .disabled(fvm.isFull == true)
                
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
                            dismissWindow(id: "BtnBoard")
                            dismissWindow(id: "Control")
                            fvm.isFull = false
                        }
                    }
                }label:{
                    if fvm.isImmersive == false{
                        VStack{
                            Text("🏥")
                                .center()
                            Text("Hospital")
                                .font(.title)
                                .center()
                        }
                    }else{
                        Text("Exit Immsersive Space")
                            .font(.extraLargeTitle)
                    }
                }.frame(width: 225, height: 100)
                .background(Color.gray)
                .cornerRadius(25)
                .buttonStyle(.plain)
                .disabled(fvm.isMix == true)
            }
            
            Text("Condition")
                .font(.extraLargeTitle)
                .bold()
                .leading()
                .padding()
            
            TabView{
                VStack{
                   Text("Normal")
                        .font(.title)
                }
                    .tag(0)
                
                VStack{
                    Text("Herinated Disc")
                        .font(.title)
                }.tag(1)
            }.padding()
                .background(Color.gray)
                .cornerRadius(100)
                .frame(width: 450, height: 110)
            .tabViewStyle(.page)
        }
    }
}
#Preview(windowStyle: .automatic){
    ImmersiveControl()
        .frame(width: 550, height: 500)
        .environmentObject(FunctionViewModel())
}
