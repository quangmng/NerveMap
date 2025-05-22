//
//  LearnMoreView.swift
//  NrvMap 3D
//
//  Created by Wende Zhou on 18/5/2025.
//

import SwiftUI

struct LearnMoreView: View {

    @State private var selectedNerveLevel: String? = nil
    @State private var selectedArea: String? = nil
    @EnvironmentObject var fvm: FunctionViewModel

    // Compute unique first-letter categories (e.g., V, C, T, L, S)
    private var nerveLevelPrefixes: [String] {
        let prefixes = allDermatomes.map { String($0.nerveLevel.prefix(1)) }
        return Array(Set(prefixes)).sorted()
    }

    // Helper method to filter dermatomes by nerve level
    private func dermatomesForNerveLevel(_ level: String) -> [Dermatome] {
        return allDermatomes.filter { $0.nerveLevel.hasPrefix(level) }
    }

    var body: some View {
        VStack {

            // Nerve Level Selection
            VStack {
                Text("Choose the dermatome area👇🏻")
                    .font(.system(size: 55, design: .rounded))
                HStack {
                    ForEach(nerveLevelPrefixes, id: \.self) { prefix in
                        Button {
                            withAnimation(.spring()) {
                                // Toggle selection of this prefix
                                if selectedNerveLevel == prefix {
                                    selectedNerveLevel = nil
                                    // Clear any selected sub-area when deselecting
                                    selectedArea = nil
                                } else {
                                    selectedNerveLevel = prefix
                                }
                            }
                        } label: {
                            Text(prefix)
                                .font(
                                    .system(
                                        size: 70,
                                        weight: .bold,
                                        design: .rounded
                                    )
                                )
                                .foregroundColor(.primary)
                                .frame(width: 100, height: 100)
                                .padding()
                        }
                        .buttonBorderShape(.circle)
                        .padding()
                    }
                }
                .padding(.bottom, 20)

                // Subcategory List (e.g., T1, T2, etc.)
                if let nerveLevel = selectedNerveLevel {
                    VStack {
                        Text("Choose More Details👇🏻")
                            .font(.system(size: 55, design: .rounded))
                        HStack{
                            ForEach(dermatomesForNerveLevel(nerveLevel)) { dermatome in
                                Button {
                                    withAnimation {
                                        selectedArea = dermatome.nerveLevel

                                        if fvm.selectedEntity != nil {
                                            fvm.stopBlinkingHighlight(for: fvm.selectedEntity!)
                                        }

                                        if fvm.isMale == false {
                                            fvm.selectedEntity = fvm.femaleModel?.findEntity(named: dermatome.nerveLevel.lowercased())
                                            fvm.startBlinkingHighlight(for: fvm.selectedEntity!)

                                        }
                                        else if fvm.isMale == true{
                                            fvm.selectedEntity = fvm.maleModel?.findEntity(named: dermatome.nerveLevel.lowercased())
                                            fvm.startBlinkingHighlight(for: fvm.selectedEntity!)
                                        }
                                        print(fvm.selectedEntity?.name)
                                    }
                                } label: {
                                    Text(dermatome.nerveLevel)
                                        .font(
                                            .system(
                                                size: 60,
                                                weight: .bold,
                                                design: .rounded
                                            )
                                        )
                                        .foregroundColor(.primary)
                                        .frame(width: 120, height: 100)
                                        .padding()
                                }
                                .buttonBorderShape(.circle)
                                .padding()
                            }
                        }
                    }
                    .transition(.opacity)
                }
            }

            // Display selected dermatome info (e.g., "T1" info)
            if let area = selectedArea {
                if let dermatome = allDermatomes.first(where: { $0.nerveLevel == area }) {
                    HStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.green.opacity(0.8))
                            .frame(width: 200, height: 200)
                            .overlay {
                                Text(dermatome.nerveLevel)
                                    .font(
                                        .system(
                                            size: 70,
                                            weight: .bold,
                                            design: .rounded
                                        )
                                    )
                            }

                        VStack(alignment: .leading) {
                            Text("Area Detail: \(dermatome.area)")
                                .font(.system(size: 50, weight: .semibold))
                                .foregroundColor(.primary)
                                .padding(.bottom, 5)
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.clear)
                                        .frame(maxWidth: .infinity)
                                }

                            Text("More Info: \(dermatome.clinicalNote)")
                                .font(.system(size: 45, weight: .regular))
                                .foregroundColor(.primary)
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.clear)
                                        .frame(maxWidth: .infinity)
                                }
                        }
                    }
                    .transition(.opacity)
                }
            }
        }.onDisappear{if fvm.selectedEntity != nil {
            fvm.stopBlinkingHighlight(for: fvm.selectedEntity!)
        }}
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    LearnMoreView()
        .environmentObject(FunctionViewModel())
}

