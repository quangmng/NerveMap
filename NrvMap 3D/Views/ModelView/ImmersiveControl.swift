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
    let defaultPosition = SIMD3<Float>(x: -0.7, y: 0.9, z: -1)

    var body: some View {
        VStack(spacing: 30) {
            if fvm.isMix == false && fvm.isImmersive == false {
                Text("Choose the Environment")
                    .font(.system(size:40))
                    .fontWeight(.heavy)
                    .animation(.spring(), value: fvm.isMix)
            }

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
                                dismissWindow(id: "Control")
                                openWindow(id: "WelcomeView")
                                fvm.isMix = false
                            }
                        }
                    } label: {
                        if fvm.isImmersive == false{
                            Text("Real-Life")
                                .font(.largeTitle)
                                .frame(width: 200, height: 100)
                        } else {
                            Text("Exit Mode")
                                .font(
                                    .system(
                                        size: 40,
                                        weight: .bold,
                                        design: .rounded
                                    )
                                )
                                .frame(width: 200, height: 100)
                                .foregroundStyle(Color.red.secondary)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .disabled(fvm.isFull == true)
                }

                // MARK: - Enter Full Immersive
                if fvm.isImmersive == false || fvm.isFull  == true {
                    Button{
                        Task {
                            if fvm.isImmersive == false {
                                showAlert = true

                            } else {
                                await dismissImmersiveSpace()
                                fvm.isImmersive = false
                                dismissWindow(id: "Control")
                                openWindow(id: "WelcomeView")
                                fvm.isFull = false
                            }
                        }
                    } label: {
                        if fvm.isImmersive == false{
                            Text("Hospital")
                                .font(.largeTitle)
                                .frame(width: 200, height: 100)
                        } else {
                            Text("Exit Mode")
                                .font(
                                    .system(
                                        size: 40,
                                        weight: .bold,
                                        design: .rounded
                                    )
                                )

                                .frame(width: 200, height: 100)
                                .foregroundStyle(Color.red.secondary)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
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
                
                if fvm.isImmersive {
                    Button{
                        fvm.maleModel?.position = defaultPosition
                        fvm.femaleModel?.position = defaultPosition
                    }label:{
                        Image(systemName: "person.fill.viewfinder")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }.toggleStyle(.button)
                        .padding(12)
                        .buttonStyle(.borderless)
                        .buttonBorderShape(.circle)
                        .labelStyle(.iconOnly)
                        .padding(12)
                        .glassBackgroundEffect(in: .rect(cornerRadius: 60))
                        .help("Recenter")
                }
            }

            // MARK: - Test this visiable and functionality
            if fvm.isImmersive {
                ButtonBoard()
            }
        }
        .padding(25)
    }
}
#Preview(windowStyle: .automatic){
    ImmersiveControl()
        .frame(width: 550, height: 470)
        .environmentObject(FunctionViewModel())
}
