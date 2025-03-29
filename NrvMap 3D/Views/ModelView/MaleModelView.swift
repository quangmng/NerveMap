//
//  MaleModelView.swift
//  NrvMap 3D
//
//  Created by Ian So on 26/3/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct MaleModelView: View {
    
    //Listing the Model mesh
    @State var modelMesh: [ModelMesh] = []
    @State private var modelEntity: Entity?
    @State private var originalTransform: Transform?
    
    var body: some View {
        
        RealityView { content, attachments  in
            
            if let modelEntity = try? Entity.load(named: "FemalDModel") {
                modelEntity.position = SIMD3(0,0,-0.5)
                modelEntity.components.set(InputTargetComponent())
                content.add(modelEntity)
                
            }else{
                print("Fail to load model")
            }
            
            
        }update: { content, attachments in
            
            do{}
            
            for mesh in modelMesh{
                
                if let meshEntity = attachments.entity(for: mesh.id) {
                    
                    content.add(meshEntity)
                    meshEntity.look(at: .zero, from: mesh.location, relativeTo: meshEntity.parent)
                    
                }
            }
            
        } attachments: {
            
            ForEach(modelMesh) { mesh in
                Attachment(id: mesh.id){
                    Text(mesh.name)
                        .glassBackgroundEffect()
                        .tag(mesh.id)
                    
                    
                }
            }
            
        }
    }
}


#Preview(windowStyle: .volumetric) {
    MaleModelView()
        .volumeBaseplateVisibility( .visible)
        
}
