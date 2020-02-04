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
        static let selectedSegment = "selectedSegment"
    }
    
    private var timeIncrementsForTimer: [Double] = [10, 15, 30, 60]
    
    var timeIncrement: Double {
        return timeIncrementsForTimer[selectedSegmentIndexForTimer]
    }
    
    var selectedSegmentIndexForTimer: Int {
        get {
            if let index = UserDefaults.standard.object(forKey: Keys.selectedSegment) as? Int {
                return index
            } else {
                UserDefaults.standard.set(2, forKey: Keys.selectedSegment)
                return 2
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.selectedSegment)
        }
    }
    
}
