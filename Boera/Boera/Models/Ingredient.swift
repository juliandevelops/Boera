//
//  Ingredient.swift
//  Boera
//
//  Created by Julian Schumacher on 14.05.25.
//

import Foundation
import SwiftUI

internal struct Ingredient : Codable, Equatable {
    
    internal var name : String
    
    internal var description : String?
    
    internal var imageName : String?
    
    internal var imageBytes : Data?
    
    internal init(name: String, description: String? = nil, imageName: String) {
        self.name = name
        self.description = description
        self.imageName = imageName
        self.imageBytes = nil
    }
    
    internal init(name: String, description: String? = nil, imageBytes : Data?) {
        self.name = name
        self.description = description
        self.imageName = nil
        self.imageBytes = imageBytes
    }
    
    internal func isCustom() -> Bool {
        return imageName == nil
    }
}
