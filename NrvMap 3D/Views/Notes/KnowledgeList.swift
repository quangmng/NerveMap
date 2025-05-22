//
//  KnowledgeList.swift
//  NrvMap 3D
//
//  Created by Wendy Zhou on 10/4/2025.
//

import SwiftUI

struct KnowledgeList: View {
    var body: some View {
        List(allDermatomes) { derm in
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 100, height: 100)
                    .overlay {
                        Text(derm.nerveLevel)
                            .font(.system(size: 45, weight: .bold))
                            .foregroundColor(.black)
                    }
                
                Spacer().frame(width: 20)
                
                VStack(alignment: .leading) {
                    Text(derm.area)
                        .font(.system(size: 35, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(derm.clinicalNote)
                        .font(.system(size: 30, weight: .regular))
                        .foregroundColor(.primary)
                        .lineLimit(3)  // Limit the clinical note lines to make it cleaner
                        .truncationMode(.tail)  // Truncate long text
                }
            }
        }
        //        .listStyle(PlainListStyle())
    }
}

#Preview {
    KnowledgeList()
}

