//
//  CocktailTests.swift
//  CocktailBookTests
//
//  Created by SOHAM PAUL on 15/12/24.
//

import XCTest
@testable import CocktailBook

class CocktailTests: XCTestCase {
    
    var cocktail: Cocktail!
    
    override func setUp() {
        super.setUp()
        
        let jsonData = """
        {
            "id": "1",
            "name": "Cocktail 1",
            "type": "Alcoholic",
            "shortDescription": "Short description",
            "longDescription": "Long description",
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
    }
    
    override func tearDown() {
        super.tearDown()
        cocktail = nil
    }
    
    func testCocktailInitialization() {
        XCTAssertNotNil(cocktail)
    }
    
    func testCocktailId() {
        XCTAssertEqual(cocktail.id, "1")
    }
    
    func testCocktailName() {
        XCTAssertEqual(cocktail.name, "Cocktail 1")
    }
    
    func testCocktailType() {
        XCTAssertEqual(cocktail.type, "Alcoholic")
    }
    
    func testCocktailShortDescription() {
        XCTAssertEqual(cocktail.shortDescription, "Short description")
    }
    
    func testCocktailLongDescription() {
        XCTAssertEqual(cocktail.longDescription, "Long description")
    }
    
    func testCocktailPreparationMinutes() {
        XCTAssertEqual(cocktail.preparationMinutes, 10)
    }
    
    func testCocktailImageName() {
        XCTAssertEqual(cocktail.imageName, "image")
    }
    
    func testCocktailIngredients() {
        XCTAssertEqual(cocktail.ingredients, ["Ingredient 1", "Ingredient 2"])
    }
    
    func testCocktailIsFavorite() {
        XCTAssertEqual(cocktail.isFavorite, false)
    }
    
    func testDecodableCocktail() throws {
        let jsonData = """
        {
            "id": "1",
            "name": "Cocktail 1",
            "type": "Alcoholic",
            "shortDescription": "Short description",
            "longDescription": "Long description",
            "preparationMinutes": 10,
            "imageName": "image",
            "ingredients": ["Ingredient 1", "Ingredient 2"],
            "isFavorite": false
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let cocktail = try decoder.decode(Cocktail.self, from: jsonData)
        
        XCTAssertEqual(cocktail.id, "1")
        XCTAssertEqual(cocktail.name, "Cocktail 1")
        XCTAssertEqual(cocktail.type, "Alcoholic")
        XCTAssertEqual(cocktail.shortDescription, "Short description")
        XCTAssertEqual(cocktail.longDescription, "Long description")
        XCTAssertEqual(cocktail.preparationMinutes, 10)
        XCTAssertEqual(cocktail.imageName, "image")
        XCTAssertEqual(cocktail.ingredients, ["Ingredient 1", "Ingredient 2"])
        XCTAssertEqual(cocktail.isFavorite, false)
    }
}
