//
//  Stopwatch.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2019/10/25.
//  Copyright © 2019 Spawn Camping Panda. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let stopwatchDidUpdate = Notification.Name("stopwatchDidUpdate")
    static let logTimesDidUpdate = Notification.Name("logTimesDidUpdate")
}

enum WatchState {
    case running, paused, resetted
}

class Stopwatch {
    
    private(set) var elapsedTime: TimeInterval = 0.0 {
        didSet {
            NotificationCenter.default.post(Notification(name: .stopwatchDidUpdate))
        }
    }
    
    private(set) var logTimes = [TimeInterval]() {
        didSet {
            NotificationCenter.default.post(Notification(name: .logTimesDidUpdate))
        }
    }
    
//    func logTime(for index: Int) -> String {
//        return formatTime(logTimes[index])
//    }
    
    private var updateTimer: Timer! // Timer used for updating the stopwatch.
    private var deltaTime: Date?    // Time between updates.
        
    var watchState: WatchState = .resetted {
        didSet {
            switch watchState {
            case .running:
                print("Running.")
                updateTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { (timer) in
                    self.updateTime()
                }
                updateTimer!.tolerance = 0.01
                RunLoop.current.add(updateTimer!, forMode: .common)
                
            case .paused:
                print("Paused.")
                updateTime()
                updateTimer.invalidate()
                deltaTime = nil
                
            case .resetted:
                print("Resetted.")
                resetStopwatch()
            }
        }
    }

    private func updateTime() {
        elapsedTime += Date().timeIntervalSince(deltaTime ?? Date())
        deltaTime = Date()
    }
    
    func logTime() {
        guard !logTimes.contains(elapsedTime) else { return }
        logTimes.append(elapsedTime)
//        NotificationCenter.default.post(Notification(name: .logTimesDidUpdate))
    }
    
    private func resetStopwatch() {
        elapsedTime = 0.0
        deltaTime = nil
        if updateTimer != nil {
            updateTimer.invalidate()
        }
        logTimes.removeAll()
    }
    
    private func formatTime(_ rawTime: TimeInterval) -> String {
        let timeAsInt = Int(rawTime)
        let seconds = timeAsInt % 60
        let minutes = (timeAsInt / 60) % 60
        let hours = timeAsInt / 3600
        let milliseconds = Int(rawTime.truncatingRemainder(dividingBy: 1) * 100)

        return String(format: "%02i:%02i:%02i:%02i", hours, minutes, seconds, milliseconds)
    }
}
