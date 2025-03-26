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
    
    
    var body: some View {
        NavigationStack{
                    HStack{
                        VStack{
                            Text("Male")
                                .font(.extraLargeTitle)
                            
                            Button(){
                                openWindow(id: "ModelDM")
                            }label: {
                                Model3D(named: "FemaleDModel") {
                                    model in model
                                        .scaleEffect(0.09)
                                        .background(.clear)
                                }placeholder: {
                                    ProgressView()
                                }
                            }
                            .background(.clear)
                            .frame(width: 250, height: 250)
                            .padding(.top, 50)
                            .frame(maxHeight: .infinity, alignment: .top)
                        }
                        .padding(20)
                        
                        
                        VStack{
                            Text("Female")
                                .font(.extraLargeTitle)
                            
                            Button(){
                                openWindow(id: "ModelDF")
                            }label: {
                                Model3D(named: "FemaleDModel") {
                                    model in model
                                        .scaleEffect(0.09)
                                        .background(.clear)
                                }placeholder: {
                                    ProgressView()
                                }
                            }
                            .background(.clear)
                            .frame(width: 250, height: 250)
                            .padding(.top, 50)
                            .frame(maxHeight: .infinity, alignment: .top)
                        }
                        .padding(20)
                    }
                    
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("NrvMap3D")
                        .font(.extraLargeTitle)
                        .fontDesign(.rounded)
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
