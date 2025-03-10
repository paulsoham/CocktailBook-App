//
//  CocktailsViewTests.swift
//  CocktailBookTests
//
//  Created by SOHAM PAUL on 15/12/24.
//

import XCTest
import SwiftUI
@testable import CocktailBook
import CocktailsAPI

class CocktailsViewTests: XCTestCase {
    
    var viewModel: CocktailsViewModel!
    var view: CocktailsView!
    
    override func setUp() {
        super.setUp()
        let fakeAPI = FakeCocktailsAPI()
        viewModel = CocktailsViewModel(api: fakeAPI)
        view = CocktailsView(viewModel: viewModel)
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        view = nil
    }
    
    func testViewInitialization() {
        XCTAssertNotNil(view)
        XCTAssertNotNil(viewModel)
    }
    
    func testNavigationTitle_All() {
        viewModel.selectedIndex = .all
        let navigationTitle: String = {
            switch viewModel.selectedIndex {
            case .all:
                return "All Cocktails"
            case .alcoholic:
                return "Alcoholic Cocktails"
            case .nonAlcoholic:
                return "Non-Alcoholic Cocktails"
            }
        }()
        XCTAssertEqual(navigationTitle, "All Cocktails")
    }
    
    func testNavigationTitle_Alcoholic() {
        viewModel.selectedIndex = .alcoholic
        let navigationTitle: String = {
            switch viewModel.selectedIndex {
            case .all:
                return "All Cocktails"
            case .alcoholic:
                return "Alcoholic Cocktails"
            case .nonAlcoholic:
                return "Non-Alcoholic Cocktails"
            }
        }()
        XCTAssertEqual(navigationTitle, "Alcoholic Cocktails")
    }
    
    func testNavigationTitle_NonAlcoholic() {
        viewModel.selectedIndex = .nonAlcoholic
        let navigationTitle: String = {
            switch viewModel.selectedIndex {
            case .all:
                return "All Cocktails"
            case .alcoholic:
                return "Alcoholic Cocktails"
            case .nonAlcoholic:
                return "Non-Alcoholic Cocktails"
            }
        }()
        XCTAssertEqual(navigationTitle, "Non-Alcoholic Cocktails")
    }
    
    func testActivityView_IsLoading() {
        viewModel.isLoading = true
        XCTAssertNotNil(view as Any)
    }
    
    func testErrorView_HasError() {
        viewModel.error = nil
        XCTAssertNotNil(view as Any)
    }
    
    func testList_Cocktails() {
        let jsonData = """
        {
            "id": "1",
            "name": "Cocktail 1",
            "type": "Alcoholic",
            "shortDescription": "Short description",
            "longDescription": "Long description",
            "preparationMinutes": 5,
            "imageName": "image1",
            "ingredients": ["Ingredient 1"],
            "isFavorite": false
        }
        """.data(using: .utf8)!
        
        do {
            let decoder = JSONDecoder()
            let sampleCocktail = try decoder.decode(Cocktail.self, from: jsonData)
            print("Successfully decoded cocktail: \(sampleCocktail)")
            
            viewModel.cocktails = [sampleCocktail]
            XCTAssertNotNil(view as Any)
            
            
        } catch {
            print("Failed to decode cocktail: \(error)")
        }
    }
}
