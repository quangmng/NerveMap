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
    @StateObject private var noteVM = NoteViewModel()
    @State private var avm = AnnotationViewModel()
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        
        // Main window
        WindowGroup {
            ChooseModelView()
                .environmentObject(noteVM)
                .environment(appModel)
        }
        
        // Notes window
        WindowGroup(id: "NotesWindow") {
            NoteListView()
                .environmentObject(noteVM)
        }

        // Volumetric view for female model
        WindowGroup(id: "ModelDF") {
            FemaleModelView()
                .volumeBaseplateVisibility(.visible)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 600, height: 1600)
        
        // Volumetric view for male model
        WindowGroup(id: "ModelDM") {
            MaleModelView()
                .environment(avm)
                .volumeBaseplateVisibility(.visible)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 600, height: 1600)

        WindowGroup(id: "AnnotationWindow") {
            AddAnnotationVIew()
                .environment(avm)
        }
        
        // Primary Immersive Space using appModel
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
        .immersionStyle(selection: $currentStyle, in: .full)
    }
}
