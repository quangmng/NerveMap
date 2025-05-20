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
                    
                    Text("Location: Outer hip → lateral thigh → front of shin → top of the foot → big toe, Function: Sensory input, ankle dorsiflexion, and big toe movement, Associated Nerve: L5 spinal nerve")
                        .font(.title)
                    
                    Text("In Case of Herniated Disc (L4-L5)")
                        .font(.extraLargeTitle)
                        .leading()
                        .padding()
                    
                    Image("")
                    
                    Text("Location: Outer hip → lateral thigh → front of shin → top of the foot → big toe, Function: Sensory input, ankle dorsiflexion, and big toe movement, Associated Nerve: L5 spinal nerve")
                        .font(.title)
                    
                }.navigationTitle("Dermatome Level")
                
            }
        }
    }
}

#Preview (windowStyle: .automatic){
    InfoView(name: "Hello")
}

