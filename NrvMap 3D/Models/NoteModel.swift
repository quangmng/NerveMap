//
//  NoteModel.swift
//  NrvMap 3D
//
//  Created by Wende Zhou on 4/4/2025.
//

import Foundation
import simd

struct NoteModel: Identifiable, Codable {
    let id: UUID
    var title: String?
    var details: String?
    var dateCreated: Date?
    var position: CodableSIMD?
    
    struct CodableSIMD: Codable{
        
        var x: Float
        var y: Float
        var z: Float
        
        init(_ vector: SIMD3<Float>){
            self.x = vector.x
            self.y = vector.y
            self.z = vector.z
        }
        
        var codedSIMD: SIMD3<Float>{
            SIMD3<Float>(x, y, z)
        }
    }
}
