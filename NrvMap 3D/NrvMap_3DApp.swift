//
//  NrvMap_3DApp.swift
//  NrvMap 3D
//
//  Created by Quang Minh Nguyen on 3/10/25.
//

import SwiftUI
import SwiftData

@main
struct NrvMap_3DApp: App {

    @AppStorage("hasSeenWelcomeScreen") var hasSeenWelcomeScreen = false
    @State private var appModel = AppModel()
    @StateObject private var noteVM = NoteViewModel()
    @StateObject var fvm = FunctionViewModel()
    @State private var name: String = ""

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
                    .environmentObject(fvm)
                    .volumeBaseplateVisibility(.visible)
            }
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 1500, height: 1500)
        
        WindowGroup(id: "HelpWindow"){
            HelpView()
        }

        // Notes window
        WindowGroup(id: "NotesWindow") {
            NoteListView()
                .environmentObject(noteVM)
                .environmentObject(fvm)
        }
        .modelContainer(for: NoteData.self)

        WindowGroup(id: "KnowledgeList") {
            KnowledgeList()
        }

        // Volumetric view for female model

        WindowGroup(id: "Control") {
            ImmersiveControl()
                .environmentObject(noteVM)
                .environmentObject(fvm)
        }.defaultSize(width: 800, height: 500)

        ImmersiveSpace(id: "Immersive") {
            ImmersiveView()
                .environmentObject(noteVM)
                .environmentObject(fvm)
        }
        .immersionStyle(selection: $fvm.style, in: .mixed, .full, .progressive)

        // Volumetric view for male model
        WindowGroup(id: "ModelDM") {
            MaleModelView()
                .environmentObject(noteVM)
                .environmentObject(fvm)
                .volumeBaseplateVisibility(.visible)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 600, height: 1600)

        WindowGroup(id: "AnnotationWindow") {
            AddAnnotationVIew()
                .environmentObject(fvm)
        }
        .modelContainer(for: [NoteData.self])
        .defaultSize(width: 400, height: 600)
//        let container = ModelContainer(for: [NoteData.self])

        WindowGroup(id: "LearnMore") {
            LearnMoreView()
                .environmentObject(fvm)
        }
        .defaultSize(width: 2000, height: 1000)

        WindowGroup(id: "BtnBoard") {
            ButtonBoard()
                .environmentObject(fvm)
        }
        .defaultSize(width: 500, height: 200)
        
        WindowGroup (id: "InfoWindow"){
            InfoView(name: fvm.selectedEntity?.name ?? "")
                .environmentObject(fvm)
        }.defaultSize(width: 600, height: 700)
    }
}
