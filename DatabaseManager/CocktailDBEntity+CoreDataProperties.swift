//
//  CocktailDBEntity+CoreDataProperties.swift
//  CocktailBook
//
//  Created by SOHAM PAUL on 14/12/24.
//
//

import Foundation
import CoreData

extension CocktailDBEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CocktailDBEntity> {
        return NSFetchRequest<CocktailDBEntity>(entityName: "CocktailDBEntity")
    }
    @NSManaged public var id: String?
    @NSManaged public var isFavorite: Bool
}
extension CocktailDBEntity : Identifiable {}
