//
//  MotionTextView.swift
//  NrvMap 3D
//
//  Created by Wendy Zhou on 24/4/2025.
//

import SwiftUI
import RealityFoundation

struct MotionTextView: View {
    
    @State private var mmv = MaleModelView()
    @State private var modelEntity: Entity?
    @EnvironmentObject var fvm: FunctionViewModel
    
    var body: some View {
        TabView {
            VStack{
                Text("🚶🏼Walking")
                
                Button(fvm.isMoving ? "Stop" : "Start"){
                    if fvm.isMoving == false{
                        fvm.playAnimation()
                        fvm.isMoving = true
                    }else{
                        fvm.stopAnimation()
                        fvm.isMoving = false
                    }
                }
            }.onAppear{
                fvm.showWalk = true
                fvm.showSit = false
                fvm.showStand = false
                fvm.modelEntity = fvm.walkModel
            }.tag(0)
                
                VStack{
                    Text("🧍🏻Stand Up")
                    
                    Button(fvm.isMoving ? "Stop" : "Start"){
                        if fvm.isMoving == false{
                            fvm.playAnimation()
                            fvm.isMoving = true
                        }else{
                            fvm.stopAnimation()
                            fvm.isMoving = false
                        }
                    }
                }.onAppear{
                    fvm.showWalk = false
                    fvm.showSit = true
                    fvm.showStand = false
                    fvm.modelEntity = fvm.sitModel
                }.tag(1)
                
                VStack{
                    Text("🪑Sitting")
                    
                    Button(fvm.isMoving ? "Stop" : "Start"){
                        if fvm.isMoving == false{
                            fvm.playAnimation()
                            fvm.isMoving = true
                        }else{
                            fvm.stopAnimation()
                            fvm.isMoving = false
                        }
                    }
                }.onAppear{
                    fvm.showWalk = false
                    fvm.showSit = false
                    fvm.showStand = true
                    fvm.modelEntity = fvm.standModel
                }.tag(2)
            
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}

#Preview {
    MotionTextView()
}
