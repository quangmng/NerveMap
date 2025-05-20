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
    
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 30){
            Text("Environment")
                .font(.system(size:40))
                .fontWeight(.heavy)
                .padding()
                .leading()
            HStack(spacing: 30){
                
                // Mix Immersive
                // Real Life
                if fvm.isImmersive == false || fvm.isMix  == true{
                    
                    
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
                                dismissWindow(id: "Control")
                                fvm.isMix = false
                            }
                        }
                    } label: {
                        if fvm.isImmersive == false{
                            Text("Real-Life")
                                .font(.largeTitle)
                                .frame(width: 200, height: 100)
                        } else {
                            Text("Exit")
                                .font(.largeTitle)
                                .frame(width: 200, height: 100)
                                .foregroundStyle(Color.red.secondary)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 20))
                    .disabled(fvm.isFull == true)
                }
                
                // MARK: - Enter Full Immersive
                if fvm.isImmersive == false || fvm.isFull  == true{
                    Button{
                        Task {
                            if fvm.isImmersive == false {
                                showAlert = true
                                
                            } else {
                                await dismissImmersiveSpace()
                                fvm.isImmersive = false
                                openWindow(id: "WelcomeView")
                                dismissWindow(id: "Control")
                                fvm.isFull = false
                            }
                        }
                    } label: {
                        if fvm.isImmersive == false{
                            Text("Hospital")
                                .font(.largeTitle)
                                .frame(width: 200, height: 100)
                        } else {
                            Text("Exit")
                                .font(.largeTitle)
                                .frame(width: 200, height: 100)
                                .foregroundStyle(Color.red.secondary)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 20))
                    .alert("⚠️ Entering Immersive Mode" ,isPresented: $showAlert){
                        Button("Cancel", role:.cancel, action:{showAlert = false})
                        Button("Continue", action:{
                            Task{
                                fvm.style = .full
                                fvm.isFull = true
                                await openImmersiveSpace(id: "Immersive")
                                fvm.isImmersive = true
                                dismissWindow(id: "WelcomeView")
                                self.showAlert = false
                            }
                        })
                    } message: {
                        Text("Please ensure you have a safe and clear space around you before continuing.")
                    }
                    .disabled(fvm.isMix == true)
                }
            }
            
            // MARK: - Test this visiable and functionality
            if fvm.isImmersive {
                ButtonBoard()
            }
            
            /*
             Text("Condition")
             .font(.system(size:40))
             .fontWeight(.heavy)
             .leading()
             .padding()
             
             TabView{
             VStack{
             Text("Normal")
             .font(.system(size:32))
             .fontWeight(.semibold)
             .padding(.bottom, 20)
             }
             .tag(0)
             
             VStack{
             Text("Herinated Disc")
             .font(.system(size:32))
             .fontWeight(.semibold)
             .padding(.bottom, 20)
             }.tag(1)
             }.padding()
             .background(Color.white.opacity(0.09))
             .cornerRadius(30)
             .frame(width: 500, height: 130)
             .tabViewStyle(.page)
             */
        }
        .padding(25)
    }
}
#Preview(windowStyle: .automatic){
    ImmersiveControl()
        .frame(width: 550, height: 470)
        .environmentObject(FunctionViewModel())
}
