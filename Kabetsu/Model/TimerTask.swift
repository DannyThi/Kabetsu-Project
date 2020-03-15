//
//  TimerTask.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/28.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import Foundation

enum CountdownModifier {
    case increment, decrement
}

enum TimerState {
    case initialized, running, paused, ended
}

extension Notification.Name {
    static let timerDidEnd = Notification.Name("timerDidEnd")
    static let timerDidUpdate = Notification.Name("timerDidUpdate")
    static let timerStateDidChange = Notification.Name("timerStateDidChange")
}

class TimerTask {
    
    /** The **original** countdown time chosen from the collection of timers. */
    let originalCountdownTime: TimeInterval!
    
    /** The **modified** countdown time after the timer has been selected from the collection of timers. */
    private(set) var adjustedCountdownTime: TimeInterval!
    
    private var totalElapsedTimeCounter: TimeInterval = 0.0
    private var updateTimer: Timer?
    private var deltaTime: Date!
    
    /** The current elapsed time of the countdown timer.**/
    var currentCountdownTime: TimeInterval {
        let countdownTime = adjustedCountdownTime - totalElapsedTimeCounter
        if countdownTime > 0 {
            return countdownTime
        } else {
            if timerState != .ended {
                timerState = .ended
            }
            return 0
        }
    }
    
    /** The current state of the countdown timer (running, paused, ended). **/
    var timerState: TimerState = .initialized {
        didSet {
            switch timerState {
            case .initialized:
                NotificationCenter.default.post(Notification(name: .timerDidUpdate))
            case .running:
                print("TimerState: Running")
                deltaTime = Date()
                updateTimer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { (timer) in
                    self.updateTime()
                }
                updateTimer!.tolerance = 0.01
                RunLoop.current.add(updateTimer!, forMode: .common)

            case .paused:
                print("TimerState: Paused")
                updateTime()
                updateTimer?.invalidate()

            case .ended:
                print("TimerState: Ended")
                updateTimer?.invalidate()
                NotificationCenter.default.post(Notification(name: .timerDidEnd))
            }
            NotificationCenter.default.post(Notification(name: .timerStateDidChange))
        }
    }
    
    init(withTotalTime time: Double) {
        originalCountdownTime = time
        adjustedCountdownTime = time
        NotificationCenter.default.post(Notification(name: .timerDidUpdate))
    }
    
    private func updateTime() {
        totalElapsedTimeCounter += (Date().timeIntervalSince(deltaTime))
        deltaTime = Date()
        NotificationCenter.default.post(Notification(name: .timerDidUpdate))
    }
    
    func adjustCountdownTime(modifier: CountdownModifier, value: Double = 30.0, completed: (()->Void)? = nil) {
        guard timerState != .ended else { return }
        switch modifier {
        case .increment:
            guard value + currentCountdownTime < DateInterval.timeInSecondsFor24hours else { break }
            adjustedCountdownTime += value
        case .decrement:
            if currentCountdownTime > value {
                adjustedCountdownTime -= value
            }
        }
        completed?()
        NotificationCenter.default.post(Notification(name: .timerDidUpdate))
    }
}


// MARK: - Time Conversion

extension TimerTask {
    static func getTimeIntervalFromTimeComponents(hours: Int, minutes: Int, seconds: Int) -> TimeInterval {
        let h = hours * 60 * 60
        let m = minutes * 60
        let s = seconds
        return Double(h + m + s)
    }
    
    static func formattedTimeFrom(timeInterval: TimeInterval,
                                                 style: DateComponentsFormatter.UnitsStyle,
                                                 usingMilliseconds milliseconds: Bool = true) -> String
    {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = style
        formatter.zeroFormattingBehavior = formatter.unitsStyle == .positional ? .pad : .default
        formatter.allowedUnits = [.hour, .minute, .second]
        var formattedTime = formatter.string(from: timeInterval)!
        if style == .positional && milliseconds {
            let milliseconds = Int(timeInterval.truncatingRemainder(dividingBy: 1) * 100)
            formattedTime += String(format: ":%02i", milliseconds)
        }
        return formattedTime
    }
}



