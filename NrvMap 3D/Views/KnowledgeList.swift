//
//  KnowledgeList.swift
//  NrvMap 3D
//
//  Created by Wendy Zhou on 10/4/2025.
//

import SwiftUI

struct KnowledgeList: View {
    var body: some View {
        ScrollView{
            List(allDermatomes) { derm in
                VStack(alignment: .leading) {
                    Text(derm.nerveLevel)
                        .font(.headline)
                    Text(derm.area)
                        .font(.subheadline)
                    Text(derm.clinicalNote)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

#Preview {
    KnowledgeList()
}
