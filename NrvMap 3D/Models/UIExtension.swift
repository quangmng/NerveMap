//
//  PositionManager.swift
//  NrvMap 3D
//
//  Created by Ian So on 26/3/2025.
//

import SwiftUI

extension View{
    
    func leading() -> some View {
        
        self.frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
    func traling() -> some View{
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func center() -> some View{
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
}

