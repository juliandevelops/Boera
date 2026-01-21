//
//  NotificationsHandler.swift
//  Boera
//
//  Created by Julian Schumacher on 21.01.26.
//

import Foundation
import UserNotifications

internal struct NotificationsHandler {

    /// The current notification center to work on
    private static let notificationCenter : UNUserNotificationCenter = UNUserNotificationCenter.current()

    /// Requests permissions to deliver notificaitons
    /// - Throws an error if permissions cannot be requested
    internal static func requestPermission() async throws {
        try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
    }

    /// Returns the settings of the current notification center setup
    /// - Returns: settings for the current setup
    internal static func getSettings() async -> UNNotificationSettings {
        return await notificationCenter.notificationSettings()
    }

    /// Schedules a notification with the current system notification center
    /// - Parameter request: The request containing all information for the notificaiton to schedule with the system
    /// - Throws an error if notification cannot be schedules
    internal static func scheduleNotification(request : UNNotificationRequest) {
        notificationCenter.add(request)
    }
}
