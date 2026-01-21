//
//  SettingsHelper.swift
//  Boera
//
//  Created by Julian Schumacher on 12.05.25.
//

import Foundation

private enum Settings : String, RawRepresentable {
    case appVersion = "app_version_setting"
    case buildVersion = "build_version_setting"
    case useNotifications = "use_notifications_setting"
}

internal struct SettingsHelper {
    
    internal static func updateSettings() {
        UserDefaults.standard.set(Bundle.main.infoDictionary!["CFBundleShortVersionString"], forKey: Settings.appVersion.rawValue)
        UserDefaults.standard.set(Bundle.main.infoDictionary!["CFBundleVersion"], forKey: Settings.buildVersion.rawValue)
    }
}
