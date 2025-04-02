//
//  HomeView.swift
//  NrvMap 3D
//
//  Created by Ian So on 25/3/2025.
// recall-codes

import Foundation
import SwiftUI
import RealityKit
import RealityKitContent

struct HomeView: View {
  
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    NavigationLink(destination: ChooseModelView()) {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.2)
                                .background(Color.gray.opacity(0.7))
                                .cornerRadius(25)
                            
                            Text("Choose Model")
                                .font(.extraLargeTitle)
                                .foregroundColor(.white)
                                .leading()
                                .padding()
                        }
                    }
                    .buttonStyle(.plain)
                    .padding()
                    
                    HStack {
                        CustomNavLink(title: "🏃Simulation", destination: SpaceControl())
                        CustomNavLink(title: "📝Saved Note", destination: ChooseModelView())
                        CustomNavLink(title: "🔍Search", destination: SearchView())
                    }
                    
                    CustomNavLink(title: "❓Help", destination: HelpView())
                        .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.1)
                        .leading()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("NrvMap3D")
                            .font(.extraLargeTitle)
                            .fontDesign(.rounded)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview(windowStyle: .automatic) {
    HomeView()
        .environment(AppModel())
}
