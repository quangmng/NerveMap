//
//  AddAnnotationVIew.swift
//  NrvMap 3D
//
//  Created by Ian So on 10/4/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct AddAnnotationVIew: View {
    
    @Environment(AnnotationViewModel.self) private var viewModel
        @Environment(\.dismissWindow) private var dismissWindow

        @State private var title = ""
        @State private var description = ""

        var body: some View {
            VStack(spacing: 16) {
                Text("Add Note").font(.headline)
                TextField("Title", text: $title)
                TextField("Description", text: $description)
                Button("Save") {
                    if let position = viewModel.pendingLocation {
                        let newAnnotation = AnnotationModel(title: title, description: description, position: position)
                        viewModel.annotationList.append(newAnnotation)
                        viewModel.pendingLocation = nil
                    }
                    dismissWindow(id: "AnnotationWindow")
                }
            }
            .frame(width: 300)
            .padding()
        }
    }
