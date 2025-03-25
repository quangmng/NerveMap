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
    @Environment(\.openWindow) public var openWindow
    var body: some View {
        NavigationStack{
            VStack {
               
                Button("Female Model"){
                    openWindow(id: "ModelDF")
                }
                
                Text("Hello, world!")
                
            }
            
            //Title
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

#Preview(windowStyle: .automatic) {
    HomeView()
        .environment(AppModel())
}
