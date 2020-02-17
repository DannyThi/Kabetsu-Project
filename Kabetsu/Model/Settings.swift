//
//  Settings.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/31.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import Foundation
import UIKit

enum InterfaceStyle: Int, CaseIterable, Codable {
    case iOSLightMode, iOSDarkMode
    var title: String {
        switch self {
        case .iOSLightMode:
            return "Light mode"
        case .iOSDarkMode:
            return "Dark mode"
        }
    }
}



class Settings: Codable {
    static let shared = Settings()
    
    private enum Keys {
        static let timerIncrementControlSelectedIndexKey = "timerIncrementControlSelectedIndexKey"
        static let interfaceStyleFollowsIOS = "interfaceStyleFollowsIOS"
        static let interfaceStyle = "interfaceStyle"
    }
}



// MARK: - TIMER INCREMENT CONTROL

extension Settings {
    var timerIncrementControlValues: [TimeInterval] { return [10, 15, 30, 60] }
    var timerIncrementControlSelectedValue: Double {
        return timerIncrementControlValues[timerIncrementControlSelectedIndex]
    }
    var timerIncrementControlSelectedIndex: Int {
        get {
            guard let index = UserDefaults.standard.object(forKey: Keys.timerIncrementControlSelectedIndexKey) as? Int else {
                UserDefaults.standard.set(2, forKey: Keys.timerIncrementControlSelectedIndexKey)
                return 2
            }
            return index
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.timerIncrementControlSelectedIndexKey)
        }
    }
}



// MARK: - USER INTERFACE STYLE

extension Settings {
    var interfaceStyleFollowsIOS: Bool {
        get {
            guard let value = UserDefaults.standard.object(forKey: Keys.interfaceStyleFollowsIOS) as? Bool else {
                UserDefaults.standard.set(true, forKey: Keys.interfaceStyleFollowsIOS)
                return true
            }
            return value
        }
        set (followsIOS) {
            UserDefaults.standard.set(followsIOS, forKey: Keys.interfaceStyleFollowsIOS)
            updateUserInterfaceStyle(interfaceStyle)
        }
    }
    var interfaceStyle: InterfaceStyle! {
        get {
            guard let value = UserDefaults.standard.object(forKey: Keys.interfaceStyle) as? Int else {
                UserDefaults.standard.set(InterfaceStyle.iOSLightMode.rawValue, forKey: Keys.interfaceStyle)
                return InterfaceStyle.iOSLightMode
            }
            let style = InterfaceStyle(rawValue: value)!
            return style
        }
        set (style) {
            UserDefaults.standard.set(style!.rawValue, forKey: Keys.interfaceStyle)
            updateUserInterfaceStyle(style)
        }
    }
    func updateUserInterfaceStyle(_ newInterfaceStyle: InterfaceStyle) {
        if !interfaceStyleFollowsIOS {
            var iOSInterfaceStyle: UIUserInterfaceStyle
            switch newInterfaceStyle {
            case .iOSLightMode:
                iOSInterfaceStyle = .light
            case .iOSDarkMode:
                iOSInterfaceStyle = .dark
            }
            UIApplication.shared.windows.forEach { window in window.overrideUserInterfaceStyle = iOSInterfaceStyle }
        } else {
            UIApplication.shared.windows.forEach { window in window.overrideUserInterfaceStyle = .unspecified }
        }
    }
}
