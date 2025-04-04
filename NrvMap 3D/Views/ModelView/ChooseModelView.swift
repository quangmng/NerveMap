//
//  ChooseModelView.swift
//  NrvMap 3D
//
//  Created by Ian So on 26/3/2025.
//

import Foundation
import SwiftUI
import RealityKit
import RealityKitContent

struct ChooseModelView: View {
    
    @Environment(\.openWindow) public var openWindow
    @StateObject var noteVM = NoteViewModel()
    @State private var noteText: String = ""
    @State private var lastUpdate: Date = Date()
    
    var body: some View {
        TimelineView(.animation){ context in
            NavigationStack{
                
                TextField("Enter your note...", text: $noteText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(maxWidth: .infinity)
                    .fontDesign(.rounded)
                
                HStack {
                    Button {
                        if !noteText.isEmpty {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yy-MM-dd HH:mm"
                            let dateString = formatter.string(from: lastUpdate)
                            noteVM.addNote(text: noteText)
                            noteText = ""
                        }
                    } label: {
                        Text("Save note")
                            .font(.title)
                    }
                    
                    NavigationLink {
                        NoteListView(noteVM: noteVM)
                    } label: {
                        Text("See the notes")
                    }


                }
                
                HStack{
                    VStack{
                        Text("Male")
                            .font(.extraLargeTitle)
                            .fontDesign(.rounded)
                        
                        Button(){
                            openWindow(id: "ModelDM")
                        }label: {
                            Model3D(named: "FemaleDModel") {
                                model in model
                                    .scaleEffect(0.09)
                                    .background(.clear)
                                    .rotation3DEffect(
                                        Rotation3D(
                                            angle: Angle2D(degrees: 100 * context.date.timeIntervalSinceReferenceDate), axis: .y
                                        )
                                    )
                            }placeholder: {
                                ProgressView()
                            }
                        }
                        .background(.clear)
                        .frame(width: 250, height: 250)
                        .padding(.top, 50)
                        .frame(maxHeight: .infinity, alignment: .top)
                    }
                    
                    VStack{
                        Text("Female")
                            .font(.extraLargeTitle)
                            .fontDesign(.rounded)
                        
                        Button(){
                            openWindow(id: "ModelDF")
                        } label: {
                            Model3D(named: "FemaleDModel") {
                                model in model
                                    .scaleEffect(0.09)
                                    .background(.clear)
                                    .rotation3DEffect(
                                        Rotation3D(
                                            angle: Angle2D(degrees: 100 * context.date.timeIntervalSinceReferenceDate), axis: .y
                                        )
                                    )
                            }placeholder: {
                                ProgressView()
                            }
                        }
                        .background(.clear)
                        .frame(width: 250, height: 250)
                        .padding(.top, 50)
                        .frame(maxHeight: .infinity, alignment: .top)
                    }
                    
                }
                .padding(20)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("NrvMap3D")
                            .font(.extraLargeTitle)
                            .fontDesign(.rounded)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ChooseModelView()
        .environment(AppModel())
}
