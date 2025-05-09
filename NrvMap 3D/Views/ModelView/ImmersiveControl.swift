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
                                    Text("👁️")
                                        .center()
                                    Text("Real-Life")
                                        .font(.title)
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

                Button {
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
                } label: {
                    if fvm.isImmersive == false{
                        Rectangle()
                            .foregroundStyle(Color.clear)
                            .frame(width: 225, height: 100)
                            .overlay {
                                VStack{
                                    Text("🏥")
                                        .center()
                                    Text("Hospital")
                                        .font(.title)
                                        .center()
                                }
                            }
                    } else {
                        Text("Dismiss Immsersive Space")
                            .font(.title)
                            .foregroundStyle(Color.red.secondary)
                    }
                }
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
                .background(Color.white.opacity(0.09))
                .cornerRadius(20)
                .frame(width: 500, height: 150)
                .tabViewStyle(.page)
        }
    }
}
#Preview(windowStyle: .automatic){
    ImmersiveControl()
        .frame(width: 550, height: 500)
        .environmentObject(FunctionViewModel())
}
