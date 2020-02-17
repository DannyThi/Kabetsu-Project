//
//  Extensions.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/10.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

// MARK: DATE INTERVAL

extension DateInterval {
    static var timeInSecondsFor24hours: TimeInterval = 86400
}


// MARK: - LAYOUT CONSTRAINTs

extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}


