//
//  CoreDataManagerTests.swift
//  CocktailBookTests
//
//  Created by SOHAM PAUL on 15/12/24.
//

import XCTest
@testable import CocktailBook
import CoreData

class CoreDataManagerTests: XCTestCase {
    var coreDataManager: CoreDataManager!
    
    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager(forTesting: true)
        let fetchRequest: NSFetchRequest<CocktailDBEntity> = CocktailDBEntity.fetchRequest()
        do {
            let cocktails = try coreDataManager.context.fetch(fetchRequest)
            for cocktail in cocktails {
                coreDataManager.context.delete(cocktail)
            }
            try coreDataManager.context.save()
        } catch {
            XCTFail("Error deleting existing data: \(error)")
        }
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataManager = nil
    }
    
    func testSaveNewCocktail() {
        coreDataManager.saveNewCocktail(cocktailId: "1", isFavorite: true)
        let fetchRequest: NSFetchRequest<CocktailDBEntity> = CocktailDBEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", "1")
        do {
            let cocktails = try coreDataManager.context.fetch(fetchRequest)
            XCTAssertEqual(cocktails.count, 1)
            XCTAssertEqual(cocktails[0].id, "1")
            XCTAssertTrue(cocktails[0].isFavorite)
        } catch {
            XCTFail("Error fetching cocktail: \(error)")
        }
    }
    
    func testUpdateFavoriteStatus() {
        coreDataManager.saveNewCocktail(cocktailId: "1", isFavorite: true)
        coreDataManager.updateFavoriteStatus(cocktailId: "1", isFavorite: false)
        let fetchRequest: NSFetchRequest<CocktailDBEntity> = CocktailDBEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", "1")
        do {
            let cocktails = try coreDataManager.context.fetch(fetchRequest)
            XCTAssertEqual(cocktails.count, 1)
            XCTAssertEqual(cocktails[0].id, "1")
            XCTAssertFalse(cocktails[0].isFavorite)
        } catch {
            XCTFail("Error fetching cocktail: \(error)")
        }
    }
    
    func testFetchAllCocktails() {
        coreDataManager.saveNewCocktail(cocktailId: "1", isFavorite: true)
        coreDataManager.saveNewCocktail(cocktailId: "2", isFavorite: false)
        
        let cocktails = coreDataManager.fetchAllCocktails()
        XCTAssertEqual(cocktails?.count, 2)
    }
    
    func testFetchAllCocktails_Empty() {
        let cocktails = coreDataManager.fetchAllCocktails()
        XCTAssertEqual(cocktails?.count, 0)
    }
}
