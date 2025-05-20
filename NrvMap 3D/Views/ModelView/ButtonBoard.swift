//
//  ButtonBoard.swift
//  NrvMap 3D
//
//  Created by Wendy Zhou on 5/5/2025.
//

import SwiftUI
import RealityKit

struct ButtonBoard: View {

    @Environment(\.openWindow) public var openWindow
    @EnvironmentObject var fvm: FunctionViewModel
    
    var body: some View {
        HStack(spacing: 30) {
            
//            Button {
//                
//            } label: {
//                Image(systemName: "book.fill")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 100, height: 100)
//                    .padding()
//                    .background(Circle().fill(Color.mint))
//                    .foregroundStyle(.white)
//            }
            

            
            ExpandButton(id: 0, systemImage: fvm.genderSelect ? "figure.stand" : "figure.stand.dress", action: {fvm.genderSelect.toggle(); fvm.isMale.toggle()}, extraButtons: [], expendButton: $fvm.expendButton)
                .background {
                    Circle()
                        .fill(fvm.genderSelect ? Color.maleBule : Color.femalePink)
                }
                .help("Gender")
            
            ExpandButton(id: 1, systemImage: "figure.walk.motion", action: {fvm.showBox.toggle()}, extraButtons: [
                // action, label
            ], expendButton: $fvm.expendButton)
            .help("Animation")
            
            // TODO: merge this button with poses (enum)
            ExpandButton(id: 2, systemImage: "square.stack.3d.up.fill", action: {openWindow(id: "Control")}, extraButtons: [], expendButton: $fvm.expendButton)
                .help("Immersive")
            
            ExpandButton(id: 3, systemImage: "note.text", action: {}, extraButtons: [("pencil.and.scribble", {fvm.isAnnotationMode.toggle()}), ("books.vertical.fill", {openWindow(id: "NotesWindow")})], expendButton: $fvm.expendButton)
                .help("Notes")
            
            ExpandButton(id: 4, systemImage: "info.circle.fill", action: {openWindow(id: "HelpWindow")}, extraButtons: [], expendButton: $fvm.expendButton)
                .help("Info")

            ExpandButton(id: 5, systemImage: "graduationcap.fill", action: {openWindow(id: "LearnMore")}, extraButtons: [], expendButton: $fvm.expendButton)


        }.toggleStyle(.button)
            .padding(12)
            .buttonStyle(.borderless)
            .buttonBorderShape(.circle)
            .labelStyle(.iconOnly)
            .padding(12)
            .glassBackgroundEffect(in: .rect(cornerRadius: 60))
    }
}
