//
//  HomeView.swift
//  NrvMap 3D
//
//  Created by Ian So on 25/3/2025.
//  recall-codes

import Foundation
import SwiftUI
import RealityKit
import RealityKitContent

struct HomeView: View {
    @StateObject var noteVM = NoteViewModel()

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 10) {
                    
                    // Choose Model Button
                    NavigationLink(destination: ChooseModelView()) {
                        Text("Choose Model")
                            .font(.extraLargeTitle)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 300, alignment: .center)
                            .padding()
                    }
                    .buttonBorderShape(.roundedRectangle(radius: 25))
                    .padding(.horizontal, 30)

                    // Main Button Row
                    HStack(alignment: .center, spacing: 10) {
                        
                        // Simulation Button
                        NavigationLink {
                            ImmersiveControl()
                        } label: {
                            Text("🏃\nSimulation")
                                .font(.extraLargeTitle)
                                .foregroundStyle(.white)
                                .frame(maxWidth: 300, minHeight: 100, alignment: .center)
                                .padding(.horizontal, 30)
                        }

                        // Save Note Button
                        NavigationLink {
                            NoteListView()
                        } label: {
                            Text("📝\nSaved Note")
                                .font(.extraLargeTitle)
                                .foregroundStyle(.white)
                                .frame(maxWidth: 300, minHeight: 100, alignment: .center)
                                .padding(.horizontal, 30)
                        }

                        // Search Button
                        NavigationLink {
                            SearchView()
                        } label: {
                            Text("🔍\nSearch")
                                .font(.extraLargeTitle)
                                .foregroundStyle(.white)
                                .frame(maxWidth: 300, minHeight: 100, alignment: .center)
                                .padding(.horizontal, 30)
                        }
                    }
                    .buttonBorderShape(.roundedRectangle(radius: 25))
                    .padding(.horizontal)

                    Spacer().frame(height: 20)

                    // Help Button
                    NavigationLink {
                        HelpView()
                    } label: {
                        Text("❓Help")
                            .font(.extraLargeTitle)
                            .foregroundStyle(.white)
                            .padding()
                            .frame(width: 300)
                    }
                    .buttonBorderShape(.roundedRectangle(radius: 25))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .bottom])
                }
                .fontDesign(.rounded)
                .frame(maxWidth: .infinity, minHeight: 150, alignment: .center)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("NrvMap3D")
                            .font(.extraLargeTitle)
                            .fontDesign(.rounded)
                            .padding(.horizontal, 50)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview(windowStyle: .automatic) {
    HomeView()
        .environment(AppModel())
}
