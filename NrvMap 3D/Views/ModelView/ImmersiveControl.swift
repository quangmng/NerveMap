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
        VStack{
            Text("Environment")
                .font(.system(size:40))
                .fontWeight(.heavy)
                .padding()
                .leading()
            HStack{
// Mix Immersive
                Button {
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
                } label: {
                    if fvm.isImmersive == false{
                        Rectangle()
                            .foregroundStyle(Color.clear)
                            .frame(width: 225, height: 100)
                            .overlay {
                                VStack{
                                    Text("Real-Life")
                                        .font(.system(size:26))
                                        .fontWeight(.semibold)
                                        .center()
                                }
                            }
                    } else {
                        Text("Exit")
                            .font(.title)
                            .foregroundStyle(Color.red.secondary)
                    }
                }
                .disabled(fvm.isFull == true)

//Full Immersive
                Button {
                    Task {
                        if fvm.isImmersive == false {
                            showAlert = true

                        } else {
                            await dismissImmersiveSpace()
                            fvm.isImmersive = false
                            openWindow(id: "WelcomeView")
                            dismissWindow(id: "BtnBoard")
                            dismissWindow(id: "Control")
                            fvm.isFull = false
                        }
                    }
                } label: {
                    if fvm.isImmersive == false{
                        Rectangle()
                            .foregroundStyle(Color.clear)
                            .frame(width: 225, height: 100)
                            .overlay {
                                VStack{
                                    Text("Hospital")
                                        .font(.system(size:26))
                                        .fontWeight(.semibold)
                                        .center()
                                }
                            }
                    } else {
                        Text("Dismiss Immsersive Space")
                            .font(.title)
                            .foregroundStyle(Color.red.secondary)
                    }
                }
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
                }message: {
                    Text("Please ensure you have a safe and clear space around you before continuing.")
                }
                .disabled(fvm.isMix == true)
            }

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
        }
        .padding(25)
    }
}
#Preview(windowStyle: .automatic){
    ImmersiveControl()
        .frame(width: 550, height: 470)
        .environmentObject(FunctionViewModel())
}
