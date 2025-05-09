//
//  HelpView.swift
//  NrvMap 3D
//
//  Created by Ian So on 27/3/2025.
//

import SwiftUI

struct HelpView: View {
    @AppStorage("hasSeenWelcomeScreen") private var hasSeenWelcomeScreen = false
    @State private var currentPage = 0
    @Environment(\.dismissWindow) private var  dismiss
    @Environment(\.openWindow) public var open
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @State private var isVisible = false
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                
                // Page 1
                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("NrvMap 3D")
                            .font(.system(size: 60, weight: .bold))
                            .opacity(isVisible ? 1 : 0)
                        
                        Text("Digital Anatomy - Dermatomes Map")
                            .opacity(isVisible ? 1 : 0)
                            .font(.system(size:40, weight:.bold))
                        
                        Text("Learn with realistic 3D\nmodels")
                            .opacity(isVisible ? 1 : 0)
                            .font(.system(size:30))
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image("onboard1")
                        .resizable()
                        .scaledToFit()
                        .opacity(isVisible ? 1 : 0)
                        .frame(width: 300, height: 500)
                        .padding()
                }
                .frame(width: 800)
                .tag(0)
                
                
                // Page 2
                HStack(alignment: .center, spacing: 40) {
                    ZStack {
                        GeometryReader { geometry in
                            ZStack {
                                let spacingY: CGFloat = 80
                                let centerX = geometry.size.width * 0.4
                                
                                // Rotate
                                Image("rotateIcon")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .position(x: centerX - 150, y: spacingY)
                                    .opacity(isVisible ? 1 : 0)
                                
                                // Zoom In
                                Image("zoomInIcon")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .position(x: centerX-25, y: spacingY * 1.8)
                                    .opacity(isVisible ? 1 : 0)
                                
                                // Zoom Out
                                Image("zoomOutIcon")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .position(x: centerX + 80 , y: spacingY * 3)
                                    .opacity(isVisible ? 1 : 0)
                                
                                // Move Icon
                                Image("moveIcon")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .position(x: centerX + 170, y: spacingY * 4.4)
                                    .opacity(isVisible ? 1 : 0)
                                
                                // Hand Gesture
                                Image("handGesture")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 250)
                                    .position(x: geometry.size.width * 0.1, y: geometry.size.height * 0.90)
                                    .opacity(isVisible ? 1 : 0)
                            }
                        }
                        .frame(width: 400, height: 450)
                    }
                    
                    VStack{
                        Text("Manipulate 3D\ndermatome maps\nmodel like never before!!")
                            .opacity(isVisible ? 1 : 0)
                            .font(.system(size:40, weight: .bold))
                    }
                    .multilineTextAlignment(.center)
                }
                
                .tag(1)
                
                // Page 3
                HStack {
                    Image("onboard3")
                        
                        .resizable()
                        .scaledToFit()
                        .frame(width: 450, height: 450)
                        .padding(-30)
                        .opacity(isVisible ? 1 : 0)
                    
                    Text("Immersive & Learn in One\nPowerful App")
                        .opacity(isVisible ? 1 : 0)
                        .font(.system(size: 50, weight: .bold))
                        .multilineTextAlignment(.center)
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.leading, -250)
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            // Navigation Arrows
            HStack {
                Button {
                    if currentPage > 0 { currentPage -= 1 }
                } label: {
                    if currentPage > 0{
                        Image(systemName: "arrow.left.circle.fill")
                            
                            .resizable()
                            .frame(width: 40, height: 40)
                            .opacity(isVisible ? 1 : 0)
                    } else {
                        Image(systemName: "arrow.left.circle")
                           
                            .resizable()
                            .frame(width: 40, height: 40)
                            .opacity(isVisible ? 1 : 0)
                    }
                    //
                }
                .buttonBorderShape(.circle)
                .disabled(currentPage == 0)
                
                Spacer()
                
                if currentPage < 2 {
                    Button {
                        currentPage += 1
                    } label: {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .opacity(isVisible ? 1 : 0)
                            .frame(width: 40, height: 40)
                        //                            .foregroundColor(.blue)
                    }
                    .buttonBorderShape(.circle)

                } else {
                    Button {
                        dismiss(id: "HelpWindow")
                        if hasSeenWelcomeScreen == false{
                            open(id: "ModelDM")
                            dismiss(id: "WelcomeView")
                            hasSeenWelcomeScreen = true
                        }
                    } label: {
                        Text("Begin")
                            .padding(.horizontal, 30)
                            .opacity(isVisible ? 1 : 0)
                            .padding(.vertical, 12)
                    }
                }
            }
            
            .padding(.horizontal, 50)
            .padding(.bottom, 50)
        }
        .background(Color.clear)
        .onAppear {
            self.isVisible = true
        }
    }
}

#Preview(windowStyle: .automatic) {
    HelpView()
        .environment(AppModel())
}
