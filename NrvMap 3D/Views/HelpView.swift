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

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                HStack{
                    VStack{
                        Text("NrvMap 3D")
                            .font(.extraLargeTitle)
                            .frame(width:300)
                            .bold()
                            .padding(.horizontal)
                        
                        Text("Derma map learn with real 3D Model")
                            .font(.extraLargeTitle2)
                            .frame(width:300)
                            .bold()
                            .padding()
                        
                    }
                    
                    //image
                }.tag(0)

                HStack{
                    //image
                    VStack{
                        
                        //image
                        
                        Text("Controll 3D derma model model like never before")
                            .font(.extraLargeTitle)
                            .frame(width:350)
                            .bold()
                            .padding(.horizontal)
                        
                        
                    }
                }.tag(1)

                VStack{
                    Text("Immersive experience on learning")
                    .font(.extraLargeTitle)
                    .bold()
                    .padding()
                    .leading()
                    
                    Text("Learn in a app")
                    .font(.extraLargeTitle)
                    .bold()
                    .padding()
                    .leading()
                    
                    Text("Make your notes")
                    .font(.extraLargeTitle)
                    .bold()
                    .padding()
                    .leading()
                    
                }.tag(2)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            // Navigation Arrows
            HStack {
                Button() {
                    if currentPage > 0 { currentPage -= 1 }
                }label:{
                    Image(systemName: "arrow.left.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(currentPage == 0 ? .gray : .blue)
                }
                .disabled(currentPage == 0)

                Spacer()

                if currentPage < 2 {
                    Button(action: {
                        if currentPage < 2 { currentPage += 1 }
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                    }
                } else {
                    Button(action: {
                        hasSeenWelcomeScreen = true
                    }) {
                        Text("Begin")
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal, 50)
            .padding(.bottom, 30)
        }
    }
}

#Preview(windowStyle: .automatic) {
    HelpView()
        .environment(AppModel())
}

