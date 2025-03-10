//
//  CocktailDetailView.swift
//  CocktailBook
//
//  Created by SOHAM PAUL on 14/12/24.
//

import Foundation
import SwiftUI

struct CocktailDetailView: View {
    let cocktail: Cocktail
    @Binding var isFavorite: Bool
    let navigationTitle: String
    @Environment(\.presentationMode) var presentationMode
    let onToggleFavorite: () -> Void
    
    init(cocktail: Cocktail, navigationTitle: String, isFavorite: Binding<Bool>, onToggleFavorite: @escaping () -> Void) {
        self.cocktail = cocktail
        self.navigationTitle = navigationTitle
        self._isFavorite = isFavorite
        self.onToggleFavorite = onToggleFavorite
    }
    
    var body: some View {
        VStack {
            Text(cocktail.name)
                .font(.title)
                .bold()
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 12)
                .padding(.leading, 16)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Image(systemName: "clock")
                        Text("\(cocktail.preparationMinutes) minutes")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Image(cocktail.imageName)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .cornerRadius(10)
                        Spacer()
                    }
                    
                    Text(cocktail.longDescription)
                    
                    Text("Ingredients")
                        .font(.headline)
                    if (cocktail.ingredients.count) > 0 {
                        ForEach(cocktail.ingredients, id: \.self) { ingredient in
                            HStack {
                                Image(systemName: "arrowtriangle.right.fill")
                                Text(ingredient)
                            }
                        }
                    } else {
                        Text("No ingredients available")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                HStack {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.backward")
            }
            Text(navigationTitle)
                .font(.headline)
        }
                            ,trailing: Button(action: {
            onToggleFavorite()
            isFavorite.toggle()
        }) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(isFavorite ? .blue : .gray)
        })
        .onAppear {
            self.isFavorite = cocktail.isFavorite
        }
    }
}
