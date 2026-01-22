//
//  NotificationsHandler.swift
//  Boera
//
//  Created by Julian Schumacher on 21.01.26.
//

import Foundation
import UserNotifications

internal struct NotificationsHandler {

    internal static var useNotifications : Bool = true

    /// The current notification center to work on
    private static let notificationCenter : UNUserNotificationCenter = UNUserNotificationCenter.current()

    /// Returns the settings of the current notification center setup
    /// - Returns: settings for the current setup
    internal static func getSettings() async -> UNNotificationSettings {
        return await notificationCenter.notificationSettings()
    }

    /// Requests permissions to deliver notificaitons
    /// - Throws an error if permissions cannot be requested
    internal static func requestPermission() async throws {
        // If user disabled notifications in app settings, don't even bother checking permissions
        guard useNotifications else {
            cancelNotifications()
            return
        }
        let permissions = await getSettings()
        // Return if notifications are permitted
        guard permissions.authorizationStatus != .authorized else { return }
        // Handle denied notification settings
        guard permissions.authorizationStatus != .denied else { return }
        // Ask for permission, if not already happened
        if (permissions.authorizationStatus == .notDetermined) {
            try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
        }
    }

    private static func cancelNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }

    internal static func scheduleNotifications() {
        notificationCenter.getPendingNotificationRequests {
            notifications in
            // 2 Notifications per day
            // Return if notifications for 10 days are scheduled
            guard notifications.count < 20 else { return }
            for i in (notifications.count / 2)..<10 {
                // Create notification content
                let content = UNMutableNotificationContent()
                content.title = "Time to drink!"
                content.body = "Remember to drink water today"
                content.categoryIdentifier = "drink-reminder"
                content.sound = .default
                // create trigger
                let triggerDay : Date = Calendar.current.date(byAdding: .day, value: i, to: Date.now)!
                let triggerDate = Calendar.current.date(bySettingHour: 10, minute: 00, second: 00, of: triggerDay)
                let triggerComps = Calendar.current.dateComponents([.day, .month, .year], from: triggerDate!)
                let trigger = UNCalendarNotificationTrigger(
                    dateMatching: triggerComps,
                    repeats: false
                )
                let notificationRequest = UNNotificationRequest(
                    identifier: UUID().uuidString,
                    content: content,
                    trigger: trigger
                )
                scheduleNotification(notificationRequest)
            }
        }
    }

    /// Schedules a notification with the current system notification center
    /// - Parameter request: The request containing all information for the notificaiton to schedule with the system
    /// - Throws an error if notification cannot be schedules
    private static func scheduleNotification(_ request : UNNotificationRequest) {
        notificationCenter.add(request)
    }
}
