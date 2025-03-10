//
//  CocktailsViewModelTests.swift
//  CocktailBookTests
//
//  Created by SOHAM PAUL on 15/12/24.
//

import XCTest
@testable import CocktailBook
import Combine
import CocktailsAPI

class CocktailsViewModelTests: XCTestCase {
    var viewModel: CocktailsViewModel!
    var cancellables: Set<AnyCancellable>!
    var fakeAPI: FakeCocktailsAPI!
    
    override func setUp() {
        super.setUp()
        fakeAPI = FakeCocktailsAPI()
        viewModel = CocktailsViewModel(api: fakeAPI)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        fakeAPI = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertTrue(viewModel.cocktails.isEmpty)
        XCTAssertTrue(viewModel.filteredCocktails.isEmpty)
        XCTAssertTrue(viewModel.dbCocktails.isEmpty)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(viewModel.retryCount, 0)
        XCTAssertFalse(viewModel.showRetryButton)
        XCTAssertEqual(viewModel.selectedIndex, .all)
    }
    
    
    func testFetchCocktailsSuccess() {
        let expectation = XCTestExpectation(description: "Fetch cocktails successfully")
        viewModel.$cocktails
            .dropFirst()
            .sink { cocktails in
                XCTAssertEqual(cocktails.count, 13) // Adjust count based on your sample.json
                XCTAssertEqual(cocktails.first?.name, "Piña colada") // Adjust name based on your sample.json
                expectation.fulfill()
            }
            .store(in: &cancellables)
        viewModel.fetchCocktailsResponse()
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testToggleFavorite() {
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
            viewModel.cocktails = [sampleCocktail]
            viewModel.toggleFavorite(for: sampleCocktail)
            XCTAssertTrue(viewModel.cocktails[0].isFavorite)
            viewModel.toggleFavorite(for: sampleCocktail)
            XCTAssertFalse(viewModel.cocktails[0].isFavorite)
        } catch {
            print("Failed to decode cocktail: \(error)")
        }
    }
    
    
    func testRetryFetchCocktails() {
        fakeAPI = FakeCocktailsAPI(withFailure: .count(3))
        viewModel = CocktailsViewModel(api: fakeAPI)
        viewModel.fetchCocktailsResponse()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel?.retryFetchCocktails()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.viewModel?.retryFetchCocktails()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.viewModel?.retryFetchCocktails()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertEqual(self.viewModel?.retryCount ?? 0, 3)
            XCTAssertFalse(self.viewModel?.showRetryButton ?? true)
        }
    }
    
    
    func testHandleAPIError() {
        let apiError = CocktailsAPIError.unavailable
        viewModel.handleAPIError(apiError)
        XCTAssertEqual(viewModel.error, apiError)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.showRetryButton)
    }
    
    
    func testShowRetryButton() {
        fakeAPI = FakeCocktailsAPI(withFailure: .count(1))
        viewModel = CocktailsViewModel(api: fakeAPI)
        let expectation = XCTestExpectation(description: "Show retry button")
        viewModel.$showRetryButton
            .dropFirst()
            .sink { showRetryButton in
                if showRetryButton {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.fetchCocktailsResponse()
        wait(for: [expectation], timeout: 5.0)
    }
    
    
    func testFetchCocktailsFailure() {
        fakeAPI = FakeCocktailsAPI(withFailure: .count(1))
        viewModel = CocktailsViewModel(api: fakeAPI)
        let expectation = XCTestExpectation(description: "Fetch cocktails fails")
        viewModel.$error
            .dropFirst()
            .sink { error in
                if let error = error {
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.fetchCocktailsResponse()
        wait(for: [expectation], timeout: 5.0)
    }
    
}
