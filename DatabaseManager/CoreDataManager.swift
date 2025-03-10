//
//  CoreDataManager.swift
//  CocktailBook
//
//  Created by SOHAM PAUL on 14/12/24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "CocktailDB")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    #if DEBUG
     public init(forTesting: Bool) {
         container = NSPersistentContainer(name: "CocktailDB")
         container.loadPersistentStores { _, error in
             if let error = error {
                 fatalError("CoreData failed to load: \(error.localizedDescription)")
             }
         }
     }
     #endif
    
    
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Failed to save context: \(error)")
            }
        }
    }
    
    func saveNewCocktail(cocktailId: String, isFavorite: Bool) {
        let cocktail = CocktailDBEntity(context: context)
        cocktail.id = cocktailId
        cocktail.isFavorite = isFavorite
        saveContext()
    }

    func updateFavoriteStatus(cocktailId: String, isFavorite: Bool) {
        let request: NSFetchRequest<CocktailDBEntity> = CocktailDBEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", cocktailId)
        
        do {
            if let cocktail = try context.fetch(request).first {
                cocktail.isFavorite = isFavorite
                saveContext()
            } else {
                saveNewCocktail(cocktailId: cocktailId, isFavorite: isFavorite)
            }
        } catch {
            print("Error saving favorite status: \(error)")
        }
    }

    
     func fetchAllCocktails() -> [CocktailDBEntity]? {
           let request: NSFetchRequest<CocktailDBEntity> = CocktailDBEntity.fetchRequest()
           do {
               let cocktails = try context.fetch(request)
               return cocktails
           } catch {
               print("Error fetching cocktails: \(error)")
               return nil
           }
       }
}
