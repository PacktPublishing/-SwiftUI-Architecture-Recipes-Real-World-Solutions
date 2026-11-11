//
//  VegetableCellView.swift
//  MyGreenPlace
//
//  Created by Mohammad Azam on 11/20/25.
//

import SwiftUI

struct VegetableRow: View {
    let vegetable: Vegetable
    
    var body: some View {
        HStack(spacing: 16) {
            
            AsyncImage(url: vegetable.thumbnailImage) { img in
                img.resizable()
                    .frame(width: 75, height: 75)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView("Loading...")
            }
            
            Text(vegetable.name)
                .font(.headline)
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 8)
    }
}

