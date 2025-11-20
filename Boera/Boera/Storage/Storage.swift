//
//  Storage.swift
//  Boera
//
//  Created by Julian Schumacher on 14.05.25.
//

import Foundation

/// Internal list to load ingredients from directly from JSON
private struct IngredientsList : Codable {
    fileprivate var ingredients : [Ingredient]
}

internal struct Storage {
    
    internal static func loadBuildInIngredients() throws -> [Ingredient] {
        // TODO: throw error ?
        guard let path = Bundle.main.path(forResource: "ingredients", ofType: "json") else { return [] }
        let data = try Data(contentsOf: URL(filePath: path), options: .mappedIfSafe)
        let decoded = try JSONDecoder().decode(IngredientsList.self, from: data)
        return decoded.ingredients
    }
}
