//
//  AddEntryIntent.swift
//  Boera
//
//  Created by Julian Schumacher on 19.01.26.
//

import AppIntents
import Foundation
import SwiftUI

internal struct AddEntryIntent: AppIntent {
    static var title: LocalizedStringResource = "Log a drink"

    static var description: IntentDescription? = IntentDescription("Provides the option to log your most recent drink")

    static var supportedModes: IntentModes = [.background]

    @Parameter(
        title: "amount",
        description: "The amount you just drank in ml",
        requestValueDialog: IntentDialog("How much did you drink?")
    ) var amount: Int

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let context = PersistenceController.shared.container.viewContext
        let drink = DrinkEntry(context: context)
        drink.amount = Int16(amount)
        drink.timestamp = Date()
        do {
            try context.save()
        } catch {
            return .result(dialog: IntentDialog("Error saving drink"))
        }
        return .result(dialog: IntentDialog("Successfully saved drink"))
    }
}

