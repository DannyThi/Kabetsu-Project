//
//  Randomizer.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/03/19.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let randomRangeDidChange = Notification.Name("randomRangeDidChange")
    static let randomGeneratorDidReset = Notification.Name("randomGeneratorDidReset")
}

class RandomNumberSelector {
    
    static let minimumSettableValue = 1
    static let maximumSettableValue = 100
    
    private(set) var usedNumbers: [Int] = []
    
    private(set) var minimum: Int
    private(set) var maximum: Int
    private(set) var selectedResult: Int? = nil

    init(withMinValue minVal: Int, maxValue maxVal: Int) {
        self.minimum = max(RandomNumberSelector.minimumSettableValue, minVal)
        self.maximum = min(max(minVal, maxVal), RandomNumberSelector.maximumSettableValue)
        NotificationCenter.default.post(Notification(name: .randomRangeDidChange))
    }
    
    func set(minVal: Int, maxVal: Int) {
        self.minimum = max(RandomNumberSelector.minimumSettableValue, minVal)
        self.maximum = min(maxVal, RandomNumberSelector.maximumSettableValue)
    }
    
    func chooseRandom() -> Int {
        let random = Int.random(in: minimum...maximum)
        if usedNumbers.contains(random) {
            return chooseRandom()
        }
        usedNumbers.append(random)
        return random
    }
    
    func reset() {
        usedNumbers = []
        selectedResult = nil
        NotificationCenter.default.post(Notification(name: .randomGeneratorDidReset))
    }
    
    
    
}
