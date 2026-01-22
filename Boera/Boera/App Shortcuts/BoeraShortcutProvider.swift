//
//  BoeraShortcutProvider.swift
//  Boera
//
//  Created by Julian Schumacher on 21.01.26.
//

import AppIntents
import Foundation

internal struct BoeraShortcutProvider : AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddEntryIntent(),
            phrases: [
                "Log $\(.applicationName)",
                "Log a drink entry with \(.applicationName)"
            ],
            shortTitle: "Log a drink entry",
            systemImageName: "waterbottle"
        )
    }
}
