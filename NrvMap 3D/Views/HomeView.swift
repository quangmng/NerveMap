//
//  HomeView.swift
//  NrvMap 3D
//
//  Created by Ian So on 25/3/2025.
//

import Foundation
import SwiftUI
import RealityKit
import RealityKitContent

struct HomeView: View {
  
    var body: some View {
        NavigationStack{
            VStack{
                
                NavigationLink(destination: ChooseModelView()) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 1232, height: 220)
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
                
                
                HStack{
                    
                    CustomNavLink(title: "🏃Simulation", destination: ChooseModelView())
                    
                    
                    CustomNavLink(title: "📝Saved Note", destination: ChooseModelView())
                    
                    CustomNavLink(title: "🔍Search", destination: SearchView())
                    
                    
                }
                
                CustomNavLink(title: "❓Help", destination: ChooseModelView())
                    .frame(width: 250, height: 100)
                    .leading()
                
                
                
            }
                    
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("NrvMap3D")
                        .font(.extraLargeTitle)
                        .fontDesign(.rounded)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingView()){
                        
                        Image(systemName: "gear")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 50)
                            
                            
                            
                        
                    }
                }
            }
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    HomeView()
        .environment(AppModel())
}
