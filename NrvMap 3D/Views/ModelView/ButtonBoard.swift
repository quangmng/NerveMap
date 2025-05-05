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
        HStack(spacing: 10) {

            ExpendButton(id: 0, systemImage: fvm.genderSelect ? "figure.stand" : "figure.stand.dress", action: {fvm.genderSelect.toggle()}, extraButtons: [], expendButton: $fvm.expendButton)
                .background(fvm.genderSelect ? Color.maleBule : Color.femalePink)
                .cornerRadius(25)
                .help("Gender")

            ExpendButton(id: 1, systemImage: "figure.walk.motion", action: {openWindow(id:"MotionWindow")}, extraButtons: [
                // action, label
            ], expendButton: $fvm.expendButton)
            .help("Animation")

            // TODO: merge this button with poses (enum)
            ExpendButton(id: 2, systemImage: "square.stack.3d.up.fill", action: {openWindow(id: "Control")}, extraButtons: [], expendButton: $fvm.expendButton)
                .help("Immersive")

            ExpendButton(id: 3, systemImage: "note.text", action: {}, extraButtons: [("note.text", {fvm.isAnnotationMode.toggle()}), ("list.clipboard", {openWindow(id: "NotesWindow")})], expendButton: $fvm.expendButton)
                .help("Notes")

            ExpendButton(id: 4, systemImage: "info.circle.fill", action: {openWindow(id: "HelpWindow")}, extraButtons: [], expendButton: $fvm.expendButton)
                .help("Info")
        }
    }
}
