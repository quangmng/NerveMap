//
//  LearnMoreView.swift
//  NrvMap 3D
//
//  Created by Wende Zhou on 18/5/2025.
//

import SwiftUI

struct LearnMoreView: View {
    @State private var showingMoreInfo = false
    @State private var selectedNerveLevel: String? = nil
    @State private var selectedArea: String? = nil
    
    // Helper method to filter dermatomes by nerve level
    private func dermatomesForNerveLevel(_ level: String) -> [Dermatome] {
        return allDermatomes.filter { $0.nerveLevel.hasPrefix(level) }
    }
    
    private var imagesFrame: Double {
        showingMoreInfo ? 326 : 50
    }

    var body: some View {
        VStack {
            Spacer()
            
            // Nerve Level Selection
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            selectedNerveLevel = selectedNerveLevel == "T" ? nil : "T"
                        }
                    }) {
                        Text("T")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.primary)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.primary, lineWidth: 2))
                    }
                    .padding()

                    Button(action: {
                        withAnimation {
                            selectedNerveLevel = selectedNerveLevel == "S" ? nil : "S"
                        }
                    }) {
                        Text("S")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.primary)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.primary, lineWidth: 2))
                    }
                    .padding()
                }
                .padding(.bottom, 20)
                
                // Subcategory List (e.g., T1, T2, etc.)
                if let nerveLevel = selectedNerveLevel {
                    VStack {
                        ForEach(dermatomesForNerveLevel(nerveLevel)) { dermatome in
                            Button(action: {
                                withAnimation {
                                    selectedArea = dermatome.nerveLevel
                                }
                            }) {
                                Text(dermatome.nerveLevel)
                                    .font(.system(size: 25, weight: .semibold))
                                    .foregroundColor(.primary)
                                    .padding(.vertical, 5)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .strokeBorder(Color.primary, lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .transition(.slide)
                }
            }
            
            // Display selected dermatome info (e.g., "T1" info)
            if let area = selectedArea {
                if let dermatome = allDermatomes.first(where: { $0.nerveLevel == area }) {
                    HStack {
                        Text(dermatome.area)
                            .font(.system(size: 25, weight: .semibold))
                            .foregroundColor(.primary)
                            .padding(.bottom, 5)
                        
                        Text(dermatome.clinicalNote)
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.primary)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20).fill(Color.gray.opacity(0.1)))
                    }
                    .padding()
                    .transition(.opacity)
                }
            }
        }
        .padding()
    }
}

#Preview {
    LearnMoreView()
}

