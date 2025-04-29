//
//  AddAnnotationVIew.swift
//  NrvMap 3D
//
//  Created by Ian So on 10/4/2025.
//

import SwiftUI
import CoreData
import RealityKit
import RealityKitContent

struct AddAnnotationVIew: View {
    
    @Environment(\.dismissWindow) private var dismissWindow
    @EnvironmentObject var noteVM: NoteViewModel
    @State private var title = ""
    @State private var content = ""
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Add Note").font(.headline)
            TextField("Title", text: $title)
            TextField("Description", text: $content)
            Button("Save") {
                if let position = noteVM.pendingLocation {
                    noteVM.addNote(title: title, content: content, position: position, date: Date())
                    noteVM.pendingLocation = nil
                }
                dismissWindow(id: "AnnotationWindow")
            }
            
            Button("Cancel") {
                dismissWindow(id: "AnnotationWindow")
            }
        }
        .frame(width: 300)
        .padding()
        .onAppear {
            noteVM.fetchCoreData()
        }
    }
}
