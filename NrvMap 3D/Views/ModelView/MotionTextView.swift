//
//  MotionTextView.swift
//  NrvMap 3D
//
//  Created by Wendy Zhou on 24/4/2025.
//

import SwiftUI
import RealityFoundation

struct MotionTextView: View {
    
    @EnvironmentObject var fvm: FunctionViewModel
    
    var body: some View {
        TabView {
            tabContent(title: "🚶🏼Walking", setModel: {
                fvm.showWalk = true
                fvm.showSit = false
                
                fvm.modelEntity = fvm.walkModel
            })
            .tag(0)
            
            tabContent(title: "🧍🏻Stand Up", setModel: {
                fvm.showWalk = false
                fvm.showSit = true
                
                fvm.modelEntity = fvm.sitModel
            })
            .tag(1)
            
            tabContent(title: "🪑Sitting", setModel: {
                fvm.showWalk = false
                fvm.showSit = false
                
                fvm.modelEntity = fvm.standModel
            })
            .tag(2)
        }
    }
    
    @ViewBuilder
    private func tabContent(title: String, setModel: @escaping () -> Void) -> some View {
        VStack {
            Text(title)
                .font(.system(size: 30))
                .fontWeight(.semibold)
            
            Button(action: {
                if fvm.isMoving {
                    fvm.stopAnimation()
                    fvm.isMoving = false
                } else {
                    fvm.playAnimation()
                    fvm.isMoving = true
                }
            }) {
                Text(fvm.isMoving ? "Stop" : "Start")
                    .font(.system(size: 26, weight: .bold))
                    .padding()
                    .cornerRadius(3)
            }
        }
        .onAppear(perform: setModel)
    }
}

#Preview {
    MotionTextView()
        .environmentObject(FunctionViewModel())
}
