//
//  CocktailRowView.swift
//  CocktailBook
//
//  Created by SOHAM PAUL on 14/12/24.
//

import SwiftUI

struct CocktailRowView: View {
    let cocktail: Cocktail
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(cocktail.name)
                    .font(.headline)
                    .foregroundColor(cocktail.isFavorite ? .blue : .primary)
                    .lineLimit(1)
                Text(cocktail.shortDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            Spacer()
            Image(systemName: cocktail.isFavorite ? "heart.fill" : "heart")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(cocktail.isFavorite ? .blue : .clear)
                .alignmentGuide(.top) { _ in 0 }
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
    }
}
