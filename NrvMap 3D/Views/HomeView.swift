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
            GeometryReader { geometry in
                VStack(spacing: 10) {
                    NavigationLink(destination: ChooseModelView()) {
                        Text("Choose Model")
                            .font(.extraLargeTitle)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 300, alignment: .center)
                            
                    }
                    .buttonBorderShape(.roundedRectangle(radius: 25))
                    .padding(.horizontal)
//                    .frame(maxWidth: .infinity)
                    
                    
                    HStack(alignment: .center, spacing: 10) {
                        NavigationLink{
                            SpaceControl()
                        } label: {
                            Text("🏃\nSimulation")
                                .font(.extraLargeTitle)
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: 300, minHeight: 100, alignment: .center)
                                .padding(.horizontal, 30)
                        }
                        
                        
                        
                        NavigationLink{
                            ChooseModelView()
                        } label: {
                            Text("📝\nSaved Note")
                                .font(.extraLargeTitle)
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: 300, minHeight: 100, alignment: .center)
                                .padding(.horizontal, 30)
                        }
                        
                        NavigationLink{
                            SearchView()
                        } label: {
                            Text("🔍\nSearch")
                                .font(.extraLargeTitle)
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: 300, minHeight: 100, alignment: .center)
                                .padding(.horizontal, 30)
                        }
                    }
                    .buttonBorderShape(.roundedRectangle(radius: 25))
                    .padding(.horizontal)
                    
                    Spacer().frame(height: 20)
                    
                    NavigationLink {
                        HelpView()
                    } label: {
                        Text("❓Help")
                            .font(.extraLargeTitle)
                            .foregroundStyle(Color.white)
                            .padding()
                            .frame(width: 300)
                    }
                    .buttonBorderShape(.roundedRectangle(radius: 25))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .bottom])

//                    CustomNavLink(title: "❓Help", destination: HelpView())
//                        .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.1)
                }
                .fontDesign(.rounded)
                .frame(maxWidth: .infinity, minHeight: 150, alignment: .center)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("NrvMap3D")
                            .font(.extraLargeTitle)
                            .fontDesign(.rounded)
                            .padding(.horizontal, 50)
                    }
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    HomeView()
        .environment(AppModel())
}
