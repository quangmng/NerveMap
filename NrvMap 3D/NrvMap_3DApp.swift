//
//  NrvMap_3DApp.swift
//  NrvMap 3D
//
//  Created by Quang Minh Nguyen on 3/10/25.
//

import SwiftUI

@main
struct NrvMap_3DApp: App {
    
    @State private var appModel = AppModel()
    @StateObject private var noteVM = NoteViewModel()
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ChooseModelView()
                .environmentObject(noteVM)
                .environment(appModel)
        }
        
        WindowGroup(id: "NotesWindow") {
            NoteListView()
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
            MaleModelView()
        }
        
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
