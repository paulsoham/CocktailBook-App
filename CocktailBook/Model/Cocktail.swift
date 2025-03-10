//
//  Cocktail.swift
//  CocktailBook
//
//  Created by SOHAM PAUL on 14/12/24.
//

import Foundation

struct Cocktail: Identifiable, Decodable {
    let id: String
    let name: String
    let type: String
    let shortDescription: String
    let longDescription: String
    let preparationMinutes: Int
    let imageName: String
    let ingredients: [String]
    var isFavorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name, type, shortDescription, longDescription, preparationMinutes, imageName, ingredients, isFavorite
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? "Unknown ID"
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Unknown Cocktail"
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? "Unknown Type"
        self.shortDescription = try container.decodeIfPresent(String.self, forKey: .shortDescription) ?? "No description available"
        self.longDescription = try container.decodeIfPresent(String.self, forKey: .longDescription) ?? "No long description available"
        self.preparationMinutes = try container.decodeIfPresent(Int.self, forKey: .preparationMinutes) ?? 0
        self.imageName = try container.decodeIfPresent(String.self, forKey: .imageName) ?? "default_image"
        self.ingredients = try container.decodeIfPresent([String].self, forKey: .ingredients) ?? []
        self.isFavorite = try container.decodeIfPresent(Bool.self, forKey:.isFavorite ) ?? false
    }
}




enum CocktailFilter {
    case all, alcoholic, nonAlcoholic
}
