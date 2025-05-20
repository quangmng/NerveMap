//
//  InfoView.swift
//  NrvMap 3D
//
//  Created by Ian So on 20/5/2025.
//

import SwiftUI

struct InfoView: View {
    
    @State var name: String
    
    var body: some View {
        if let selectedArea = allDermatomes.first(where: { $0.nerveLevel == name.uppercased() }){
            NavigationStack {
                
                VStack {
                    Text("\(selectedArea.nerveLevel)")
                        .font(.extraLargeTitle)
                        .leading()
                        .padding()
                    
                    Text("\(selectedArea.area)")
                        .font(.largeTitle)
                        .leading()
                        .padding()
                    
                    Text("In Case of Herniated Disc (L4-L5)")
                        .font(.extraLargeTitle)
                        .leading()
                        .padding()
                    
                    Image("")
                    
                    Text("\(selectedArea.clinicalNote)")
                        .font(.largeTitle)
                        .leading()
                        .padding()
                    
                }.navigationTitle("Dermatome Level")
                
            }
        }
    }
}

#Preview (windowStyle: .automatic){
    InfoView(name: "Hello")
}

