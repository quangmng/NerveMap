//
//  NoteViewModel.swift
//  NrvMap 3D
//
//  Created by Wende Zhou on 4/4/2025.
//

import SwiftUI
import CoreData
import simd

class NoteViewModel: ObservableObject {
    @Published var notes: [NoteEntity] = []
    @Published var pendingLocation: SIMD3<Float>? = nil
    
    
    let container: NSPersistentContainer
    
    init(){
        container = NSPersistentContainer(name: "NoteCoreData")
        container.loadPersistentStores{(description, error) in
            if let error = error {
                print("ERROR: \(error)")
            }
        }
        fetchCoreData()
    }

    func addNote(title: String, content: String, position: SIMD3<Float>, date: Date) {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let newNote = NoteEntity(context: container.viewContext)
        newNote.title = title
        newNote.details = content
        newNote.dateCreated = date
        newNote.id = UUID()
        
        let codablePosition = NoteModel.CodableSIMD(pendingLocation ?? SIMD3<Float>(0,0,0))
            let encoder = JSONEncoder()
            if let encodedPosition = try? encoder.encode(codablePosition) {
                newNote.position = encodedPosition as NSObject
            }
        
        saveData()
        
    }
    
    func saveData(){
        
        do{
            try container.viewContext.save()
            fetchCoreData()
        }
        catch let error{
            
            print("ERROR: \(error)")
            
        }
        
    }
    
    func deleteData(indexSet: IndexSet){
        guard let index = indexSet.first else{return}
        let entity = notes[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    func fetchCoreData(){
        
        let request = NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
        
        do{
            notes = try container.viewContext.fetch(request)
        }
        catch let error{
            print("ERROR: Fetch fail \(error)")
        }
    }
    
    func decodePosition(from note: NoteEntity) -> SIMD3<Float>? {
        guard let data = note.position as? Data else { return nil }
        let decoder = JSONDecoder()
        if let codable = try? decoder.decode(NoteModel.CodableSIMD.self, from: data) {
            return codable.codedSIMD
        }
        return nil
    }

    
}
