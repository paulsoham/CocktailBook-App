//
//  CocktailRowViewTests.swift
//  CocktailBookTests
//
//  Created by SOHAM PAUL on 15/12/24.
//

import XCTest
import SwiftUI
@testable import CocktailBook

class CocktailRowViewTests: XCTestCase {
    
    var cocktail: Cocktail!
    var view: CocktailRowView!
    
    override func setUp() {
        super.setUp()
        
        let jsonData = """
        {
            "id": "1",
            "name": "Cocktail 1",
            "type": "Alcoholic",
            "shortDescription": "Cocktail 1 description",
            "longDescription": "Long description",
            "preparationMinutes": 5,
            "imageName": "image1",
            "ingredients": ["Ingredient 1"],
            "isFavorite": true
        }
        """.data(using: .utf8)!
        
        do {
            let decoder = JSONDecoder()
            let sampleCocktail = try decoder.decode(Cocktail.self, from: jsonData)
            print("Successfully decoded cocktail: \(sampleCocktail)")
            
            cocktail = [sampleCocktail].first
            view = CocktailRowView(cocktail: cocktail)
            
            
        } catch {
            print("Failed to decode cocktail: \(error)")
        }
    }
    
    override func tearDown() {
        super.tearDown()
        cocktail = nil
        view = nil
    }
    
    func testViewInitialization() {
        XCTAssertNotNil(view)
        XCTAssertNotNil(cocktail)
    }
    
    func testCocktailName() {
        XCTAssertEqual(view.cocktail.name, "Cocktail 1")
    }
    
    func testCocktailShortDescription() {
        XCTAssertEqual(view.cocktail.shortDescription, "Cocktail 1 description")
    }
    
    func testIsFavorite_False() {
        XCTAssertEqual(view.cocktail.isFavorite, true)
    }
    
    func testIsFavorite_True() {
        cocktail.isFavorite = true
        XCTAssertEqual(view.cocktail.isFavorite, true)
    }
}
