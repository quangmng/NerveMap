//
//  NrvMap_3DApp.swift
//  NrvMap 3D
//
//  Created by Quang Minh Nguyen on 3/10/25.
//

import SwiftUI

@main
struct NrvMap_3DApp: App {

    @State private var currentStyle: ImmersionStyle = .full
    
    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
        
        WindowGroup(id: "ModelDF"){
            FemaleModelView()
                .volumeBaseplateVisibility(.visible)
        }.windowStyle(.volumetric)
            .defaultSize(width: 600, height: 1600)
        
        
        WindowGroup(id: "ModelDM"){
            MaleModelView()
                .volumeBaseplateVisibility(.visible)
        }.windowStyle(.volumetric)
            .defaultSize(width: 600, height: 1600)
        
        ImmersiveSpace(id: "test"){
            Model3DViewTest()
        }.immersionStyle(selection: $currentStyle, in: .full)

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.progressive), in: .progressive)
    }
}
