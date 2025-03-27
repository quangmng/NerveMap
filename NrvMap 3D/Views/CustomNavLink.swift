//
//  NavigationLink.swift
//  NrvMap 3D
//
//  Created by Ian So on 27/3/2025.
//

import SwiftUI

struct CustomNavLink<Destination: View>: View {
    var title: String
    var destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            Text(title)
                .font(.extraLargeTitle)
                .fontWeight(.bold)
                .padding()
                .frame(width: 400, height: 200)
        }
        .buttonStyle(.plain)
        .background(Color.gray.opacity(0.7).cornerRadius(25))
        .padding()
    }
}

#Preview (windowStyle: .automatic) {
    CustomNavLink(title: "Choose Model", destination: Text("Test"))
}
