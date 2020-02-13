//
//  Settings.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/31.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import Foundation

class Settings: Codable {
    
    static let shared = Settings()
    private enum Keys {
        static let adjustIntervalSegConSelectedIndex = "adjustIntervalSegConSelectedIndex"
    }
    
    var adjustIntervalSegConIncrements: [TimeInterval] = [10, 15, 30, 60]
    var adjustIntervalSegConCurrentIncrementValue: Double {
        return adjustIntervalSegConIncrements[adjustIntervalSegConSelectedIndex]
    }
    
    var adjustIntervalSegConSelectedIndex: Int {
        get {
            guard let index = UserDefaults.standard.object(forKey: Keys.adjustIntervalSegConSelectedIndex) as? Int else {
                UserDefaults.standard.set(2, forKey: Keys.adjustIntervalSegConSelectedIndex)
                return 2
            }
            return index
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.adjustIntervalSegConSelectedIndex)
        }
    }
    
}
