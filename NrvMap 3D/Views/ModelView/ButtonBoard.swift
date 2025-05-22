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
            
            ExpandButton(id: 0, systemImage: fvm.genderSelect ? "figure.stand" : "figure.stand.dress", action: {fvm.genderSelect.toggle(); fvm.isMale.toggle()}, extraButtons: [], expendButton: $fvm.expendButton)
                .background {
                    Circle()
                        .fill(fvm.genderSelect ? Color.maleBule : Color.femalePink)
                }
                .help("Gender")
            
            if fvm.isImmersive == true{
                ExpandButton(id: 1, systemImage: fvm.showBox ? "hand.pinch.fill" : "hand.pinch.fill", action: {fvm.showBox.toggle()}, extraButtons: [
                    // action, label
                ], expendButton: $fvm.expendButton)
                .foregroundStyle(fvm.showBox ? Color.black : Color.white)
                .background {
                    Circle()
                        .fill(fvm.showBox ? Color.white : Color.clear)
                }
                .help("Move")
            }
            
            // TODO: merge this button with poses (enum)
            if fvm.isImmersive == false{
                ExpandButton(id: 2, systemImage: "square.stack.3d.up.fill", action: {openWindow(id: "Control")}, extraButtons: [], expendButton: $fvm.expendButton)
                    .help("Immersive")
                    .disabled(fvm.isImmersive)
            }

            ExpandButton(id: 3, systemImage: fvm.isAnnotationMode ? "character.cursor.ibeam" : "note.text", action: {if fvm.isAnnotationMode == true {fvm.isAnnotationMode.toggle() ; fvm.expendButton = nil}}, extraButtons: [("character.cursor.ibeam", {fvm.isAnnotationMode.toggle(); fvm.expendButton = nil}), ("books.vertical", {openWindow(id: "NotesWindow")})], expendButton: $fvm.expendButton)
                .foregroundStyle(fvm.isAnnotationMode ? Color.black : Color.white)
                .background {
                    Circle()
                        .fill(fvm.isAnnotationMode ? Color.white : Color.clear)
                }
                .help("Notes")

            RoundedRectangle(cornerRadius: 20).frame(width: 3, height: 50)

            ExpandButton(id: 4, systemImage: "graduationcap.fill", action: {openWindow(id: "LearnMore")}, extraButtons: [], expendButton: $fvm.expendButton)
                .help("learn")

            ExpandButton(id: 5, systemImage: "info.circle.fill", action: {openWindow(id: "HelpWindow")}, extraButtons: [], expendButton: $fvm.expendButton)
                .help("Info")


        }.toggleStyle(.button)
            .padding(12)
            .buttonStyle(.borderless)
            .buttonBorderShape(.circle)
            .labelStyle(.iconOnly)
            .padding(12)
            .glassBackgroundEffect(in: .rect(cornerRadius: 60))
    }
}
