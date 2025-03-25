//
//  SettingView.swift
//  NrvMap 3D
//
//  Created by Ian So on 25/3/2025.
//

import Foundation
import SwiftUI

public struct SettingView: View {
    public var body: some View {
        
        NavigationStack{
            
            Text("Setting")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("Setting")
                            .font(.extraLargeTitle)
                            .fontDesign(.rounded)
                    }
                }
            
        }
    }
}


#Preview (windowStyle: .automatic){
    SettingView()
}
