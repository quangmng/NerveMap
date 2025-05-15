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
                HStack(alignment: .center) {
                    Text(derm.nerveLevel)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.primary)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 200, height: 200)
                        }
                    VStack {
                        Text(derm.area)
                            .font(.system(size: 25, weight: .semibold))
                            .foregroundColor(.primary)
                        Text(derm.clinicalNote)
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.primary)
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 500, height: 600) // try
                    }
                }
            }
        }
    }
}

#Preview {
    KnowledgeList()
}
