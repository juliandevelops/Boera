//
//  BoeraApp.swift
//  Boera
//
//  Created by Julian Schumacher on 06.05.25.
//

import AppIntents
import SwiftUI
import OSLog

@main
struct BoeraApp: App {
    static private let persistenceController = PersistenceController.shared
    
    static internal let logger : Logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.example.Boera", category: "General")

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(
                    \.managedObjectContext,
                     BoeraApp.persistenceController.container.viewContext
                )
                .onAppear {
                    SettingsHelper.updateSettings()
                }
        }
    }
}
