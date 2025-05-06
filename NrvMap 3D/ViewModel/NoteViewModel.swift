//
//  NoteViewModel.swift
//  NrvMap 3D
//
//  Created by Wende Zhou on 4/4/2025.
//

import SwiftUI
import SwiftData

class NoteViewModel: ObservableObject {
    
    @Published var notes: [NoteData] = []
    
    func addNote(_ note: NoteData) {
        notes.append(note)
    }
    
    func removeNote(){
        
    }
    
}
