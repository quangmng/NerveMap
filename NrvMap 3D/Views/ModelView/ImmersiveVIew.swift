//
//  Model3D.swift
//  NrvMap 3D
//
//  Created by Ian So on 1/4/2025.
//

import Foundation
import SwiftUI
import RealityKit
import RealityKitContent
import SwiftData

struct ImmersiveView: View {
    
    @Environment(\.openWindow) public var openWindow
    @State private var angle = Angle(degrees: 1.0)
    @State private var selectedEntity: Entity?
    @State private var originalTransform: Transform?
    @State var initialScale: SIMD3<Float>? = nil
    
    @StateObject var noteVM = NoteViewModel()
    @EnvironmentObject var fvm: FunctionViewModel
    
    @State var modelEntity: Entity?
    @State var standToSit: Entity?
    @State var sitToStand: Entity?
    @State var walk: Entity?
    
    @Query(sort: \NoteData.dateCreated, order: .reverse) private var notes: [NoteData]
    
    var body: some View {
        
        RealityView{content, attachments in
            
            guard let skyboxEntity = fvm.createSkybox() else {
                print("Error loading entity")
                return
            }
            
            let walkModel = await fvm.createModel(modelName: "MaleWalk")
            fvm.walkModel = walkModel
            walk = walkModel
            
            let sitToStandModel = await fvm.createModel(modelName: "MaleSit")
            fvm.sitModel = sitToStandModel
            sitToStand = sitToStandModel
            
            let standToSitModel = await fvm.createModel(modelName: "MaleStand")
            fvm.standModel = standToSitModel
            standToSit = standToSitModel
            
            if fvm.isMix == false{
                content.add(skyboxEntity)
            }

            
            walkModel.position = [0,0,-1]
            sitToStandModel.position = [0,0,-1]
            standToSitModel.position = [0,0,-1]
            content.add(walkModel)

        }update:{ content, attachments in
            
            guard let walkModel = walk, let sitModel = sitToStand, let standModel = standToSit
            else{return}
            
            if fvm.showSit == true {
    
                fvm.worldAnchor.addChild(sitModel)
                fvm.worldAnchor.removeChild(walkModel)
                fvm.worldAnchor.removeChild(standModel)
                
                content.remove(walkModel)
                content.remove(standModel)
                content.add(sitModel)
                
            }else if fvm.showWalk == true{
                
                fvm.worldAnchor.addChild(walkModel)
                fvm.worldAnchor.removeChild(sitModel)
                fvm.worldAnchor.removeChild(standModel)
        
                content.remove(sitModel)
                content.remove(standModel)
                content.add(walkModel)
                
            }else if fvm.showStand == true{
                
                fvm.worldAnchor.addChild(standModel)
                fvm.worldAnchor.removeChild(walkModel)
                fvm.worldAnchor.removeChild(sitModel)
                
                content.remove(sitModel)
                content.remove(walkModel)
                content.add(standModel)
                
            }
            
            
        }attachments:{
            
            
        }
        .simultaneousGesture(
            ModelGestureFactory.tapGesture(
                fvm: fvm,
                selectedEntity: $selectedEntity,
                openWindow: {id in openWindow(id: id)}
            )
        )
        .simultaneousGesture(
            ModelGestureFactory.dragGesture(
                fvm: fvm,
                selectedEntity: $selectedEntity
            )
        )
        .simultaneousGesture(
            ModelGestureFactory.scaleGesture(
                fvm: fvm,
                initialScale: $initialScale
            )
        )
        .simultaneousGesture(
            ModelGestureFactory.rotationGesture(
                fvm: fvm,
                angle: $angle
            )
        )
        
    }
}




#Preview{
    ImmersiveView()
        .environmentObject(FunctionViewModel())
}
