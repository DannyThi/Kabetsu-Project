//
//  TimersList.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/28.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let TimersListDidUpdate = Notification.Name("TimersListDidUpdate")
}

final class TimersList {
    
    static let shared = TimersList()
    private static let Key = "TimersList"
    
    var timers: [TimeInterval] {
        get { return internalTimers }
        set {
            internalTimers = Array(Set(newValue)).sorted()
        }
    }
    
    // Stored
    private var internalTimers: [TimeInterval] {
        didSet {
            UserDefaults.standard.set(self.internalTimers, forKey: TimersList.Key)
            //NotificationCenter.default.post(Notification(name: .TimersListDidUpdate))
        }
    }
    
    private init() {
        let storedTimers = UserDefaults.standard.value(forKey: TimersList.Key) as? [TimeInterval]
        if let timers = storedTimers, !timers.isEmpty {
            internalTimers = Array(Set(timers)).sorted()
            print(timers)
        } else {
            internalTimers = [30.0, 60.0, 120.0, 240.0]
        }
    }
    
}

