//
//  DrinkingNotification.swift
//  Boera
//
//  Created by Julian Schumacher on 21.01.26.
//

import Foundation

internal struct DrinkingTime : Hashable {
    internal var hour : Int
    internal var minute : Int
}

internal struct DrinkingNotification {

    internal var timestamp : Set<DrinkingTime>

    internal var weekdays : Set<Int>
}
