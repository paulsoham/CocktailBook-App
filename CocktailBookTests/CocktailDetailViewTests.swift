//
//  CocktailDetailViewTests.swift
//  CocktailBookTests
//
//  Created by SOHAM PAUL on 15/12/24.
//

import XCTest
import SwiftUI
@testable import CocktailBook

class CocktailDetailViewTests: XCTestCase {
    
    var cocktail: Cocktail!
    var isFavorite: Bool = false
    var navigationTitle: String = ""
    var onToggleFavorite: () -> Void = {}
    
    override func setUp() {
        super.setUp()
        
        let jsonData = """
        {
            "id": "1",
            "name": "Cocktail 1",
            "type": "Alcoholic",
            "shortDescription": "Cocktail 1 description",
            "longDescription": "Description",
            "preparationMinutes": 10,
            "imageName": "image",
            "ingredients": ["Ingredient 1", "Ingredient 2"],
            "isFavorite": false
        }
        """.data(using: .utf8)!
        
        do {
            let decoder = JSONDecoder()
            let sampleCocktail = try decoder.decode(Cocktail.self, from: jsonData)
            print("Successfully decoded cocktail: \(sampleCocktail)")
            cocktail = [sampleCocktail].first
            
        } catch {
            print("Failed to decode cocktail: \(error)")
        }
        
        navigationTitle = "Cocktail Detail"
        onToggleFavorite = {}
    }
    
    override func tearDown() {
        super.tearDown()
        cocktail = nil
    }
    
    func testViewInitialization() {
        let view = CocktailDetailView(cocktail: cocktail, navigationTitle: navigationTitle, isFavorite: .constant(false), onToggleFavorite: onToggleFavorite)
        XCTAssertNotNil(view)
    }
    
    func testCocktailName() {
        let view = CocktailDetailView(cocktail: cocktail, navigationTitle: navigationTitle, isFavorite: .constant(false), onToggleFavorite: onToggleFavorite)
        XCTAssertEqual(view.cocktail.name, "Cocktail 1")
    }
    
    func testCocktailPreparationMinutes() {
        let view = CocktailDetailView(cocktail: cocktail, navigationTitle: navigationTitle, isFavorite: .constant(false), onToggleFavorite: onToggleFavorite)
        XCTAssertEqual(view.cocktail.preparationMinutes, 10)
    }
    
    func testCocktailImageName() {
        let view = CocktailDetailView(cocktail: cocktail, navigationTitle: navigationTitle, isFavorite: .constant(false), onToggleFavorite: onToggleFavorite)
        XCTAssertEqual(view.cocktail.imageName, "image")
    }
    
    func testCocktailLongDescription() {
        let view = CocktailDetailView(cocktail: cocktail, navigationTitle: navigationTitle, isFavorite: .constant(false), onToggleFavorite: onToggleFavorite)
        XCTAssertEqual(view.cocktail.longDescription, "Description")
    }
    
    func testCocktailIngredients() {
        let view = CocktailDetailView(cocktail: cocktail, navigationTitle: navigationTitle, isFavorite: .constant(false), onToggleFavorite: onToggleFavorite)
        XCTAssertEqual(view.cocktail.ingredients, ["Ingredient 1", "Ingredient 2"])
    }
    
    func testIsFavorite_False() {
        let view = CocktailDetailView(cocktail: cocktail, navigationTitle: navigationTitle, isFavorite: .constant(false), onToggleFavorite: onToggleFavorite)
        XCTAssertEqual(view.isFavorite, false)
    }
    
    func testIsFavorite_True() {
        let view = CocktailDetailView(cocktail: cocktail, navigationTitle: navigationTitle, isFavorite: .constant(true), onToggleFavorite: onToggleFavorite)
        XCTAssertEqual(view.isFavorite, true)
    }
}
