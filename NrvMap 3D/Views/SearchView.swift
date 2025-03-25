//
//  SearchView.swift
//  NrvMap 3D
//
//  Created by Ian So on 25/3/2025.
//

import Foundation
import SwiftUI

public struct SearchView: View {
    
    @State private var searchText = ""
    
    public var body: some View {
        NavigationStack{
            VStack{
                Text("SearchView")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Search")
                        .font(.extraLargeTitle)
                        .fontDesign(.rounded)
                }
            }
        }
        .searchable(text: $searchText)
    }
    
}


#Preview (windowStyle: .automatic){
    SearchView()
}
