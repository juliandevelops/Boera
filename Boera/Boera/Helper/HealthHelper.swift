//
//  HealthHelper.swift
//  Boera
//
//  Created by Julian Schumacher on 21.01.26.
//

import Foundation
import HealthKit

internal struct HealthHelper {

    private static let healthTypes : Set = [
        HKQuantityType(.dietaryWater)
    ]

    internal static let healthStore = HKHealthStore()

    internal static func checkPermissions() async throws {
        // Return if no health data are available
        guard HKHealthStore.isHealthDataAvailable() else { return }
        try await healthStore.requestAuthorization(toShare: healthTypes, read: healthTypes)
    }

    internal static func storeData(_ entry : DrinkEntry) async throws {
        let sample = HKQuantitySample(
            type: .init(.dietaryWater),
            quantity: HKQuantity(unit: .literUnit(with: .milli), doubleValue: Double(entry.amount)),
            start: entry.timestamp!,
            end: entry.timestamp!
        )
        try await healthStore.save(sample)
    }
}
