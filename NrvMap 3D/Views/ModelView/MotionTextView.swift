//
//  MotionTextView.swift
//  NrvMap 3D
//
//  Created by Wendy Zhou on 24/4/2025.
//

import SwiftUI

struct MotionTextView: View {
    @State private var mmv = MaleModelView()
    @State private var isMoving: Bool = false
    var body: some View {
        TabView {
            VStack{
                Text("🚶🏼Walking")
                
                Button(isMoving ? "Start" : "Stop"){
                    if let entity = mmv.maleModel{if !isMoving{entity.playAnimation(named: "" ,  transitionDuration: 0.5, startsPaused: false)}
                        isMoving = true
                    }else if let entity = mmv.maleModel{ if isMoving{entity.stopAllAnimations()
                    isMoving = false}}
                }
                
            }.tag(0)
            
            VStack{
                Text("🧍🏻Stand Up")
                
                Button(isMoving ? "Start" : "Stop"){
                    if let entity = mmv.maleModel{if !isMoving{entity.playAnimation(named: "" ,  transitionDuration: 0.5, startsPaused: false)}
                        isMoving = true
                    }else if let entity = mmv.maleModel{ if isMoving{entity.stopAllAnimations()
                    isMoving = false}}
                }
                
            }.tag(1)
            
            VStack{
                Text("🪑Sitting")
                
                Button(isMoving ? "Start" : "Stop"){
                    if let entity = mmv.maleModel{if !isMoving{entity.playAnimation(named: "" ,  transitionDuration: 0.5, startsPaused: false)}
                        isMoving = true
                    }else if let entity = mmv.maleModel{ if isMoving{entity.stopAllAnimations()
                    isMoving = false}}
                }
                
            }.tag(2)
        }
//        .frame(width: 100, height: 50)
//        .background(.ultraThickMaterial)
//        .clipShape(Capsule())
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

#Preview {
    MotionTextView()
}
