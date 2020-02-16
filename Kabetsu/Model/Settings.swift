//
//  Settings.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/31.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import Foundation
import UIKit

enum InterfaceStyle: String, Codable {
    case iOSLightMode, iOSDarkMode
}

class Settings: Codable {
    
    static let shared = Settings()
    
    private enum Keys {
        static let timerIncrementControlSelectedIndexKey = "timerIncrementControlSelectedIndexKey"
        static let interfaceStyleFollowsIOS = "interfaceStyleFollowsIOS"
        static let interfaceStyle = "interfaceStyle"
    }
    
    // TIMER INCREMENT CONTROL
    var timerIncrementControlValues: [TimeInterval] = [10, 15, 30, 60]
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
            guard let style = UserDefaults.standard.object(forKey: Keys.interfaceStyle) as? InterfaceStyle else {
                UserDefaults.standard.set(InterfaceStyle.iOSLightMode.rawValue, forKey: Keys.interfaceStyle)
                return InterfaceStyle.iOSLightMode
            }
            return style
        }
        set (interfaceStyle){
            UserDefaults.standard.set(interfaceStyle, forKey: Keys.interfaceStyle)
            updateUserInterfaceStyle(interfaceStyle)
        }
    }
    private func updateUserInterfaceStyle(_ newInterfaceStyle: InterfaceStyle) {
        if interfaceStyleFollowsIOS {
            var iOSInterfaceStyle: UIUserInterfaceStyle
            switch newInterfaceStyle {
            case .iOSLightMode:
                iOSInterfaceStyle = .light
            case .iOSDarkMode:
                iOSInterfaceStyle = .dark
            }
            print(iOSInterfaceStyle.rawValue)
            UIApplication.shared.windows.forEach { window in window.overrideUserInterfaceStyle = iOSInterfaceStyle }
        } else {
            // set it to default
        }
    }
    
}
