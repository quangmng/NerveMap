//
//  NrvMap_3DApp.swift
//  NrvMap 3D
//
//  Created by Quang Minh Nguyen on 3/10/25.
//

import SwiftUI

@main
struct NrvMap_3DApp: App {
    @State private var currentStyle: ImmersionStyle = .progressive
    @AppStorage("hasSeenWelcomeScreen") var hasSeenWelcomeScreen = false
    @State private var appModel = AppModel()
    @StateObject private var noteVM = NoteViewModel()
    @StateObject var immersiveViewModel = ImmersiveViewModel()
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        
        // Main window
        WindowGroup(id: "launch"){
            InitialLauncherView()
                .environment(appModel)
        }
        .windowStyle(.plain)
        
        WindowGroup(id: "WelcomeView"){
            if hasSeenWelcomeScreen == false {
                HelpView()
            }else{
                MaleModelView()
                    .environmentObject(noteVM)
                    .volumeBaseplateVisibility(.visible)
            }
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 2000, height: 2000)
        
        WindowGroup(id: "HelpWindow"){
            HelpView()
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
        
        
        WindowGroup(id: "Control") {
            ImmersiveControl()
                .environmentObject(immersiveViewModel)
        }
        
        ImmersiveSpace(id: "Immersive") {
            ImmersiveView()
                .environmentObject(immersiveViewModel)
        }
        
        // Volumetric view for male model
        WindowGroup(id: "ModelDM") {
            MaleModelView()
                .environmentObject(noteVM)
                .volumeBaseplateVisibility(.visible)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 600, height: 1600)

        WindowGroup(id: "AnnotationWindow") {
            AddAnnotationVIew()
                .environmentObject(noteVM)
        }
        
        WindowGroup(id: "KnowledgeList") {
            KnowledgeList()
        }
        
        WindowGroup(id: "MotionWindow") {
            MotionTextView()
        }
        .defaultSize(width: 100, height: 50)
        
       
        // Primary Immersive Space using appModel
        ImmersiveSpace(id: "xxx") {
            FemaleModelView()
//            ImmersiveView()
//                .environment(appModel)
//                .onAppear {
//                    appModel.immersiveSpaceState = .open
//                }
//                .onDisappear {
//                    appModel.immersiveSpaceState = .closed
//                }
        }
        .immersionStyle(selection: $currentStyle, in: .progressive)
    }
}
