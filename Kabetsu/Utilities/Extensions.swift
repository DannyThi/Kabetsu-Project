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

// MARK: UIVIEW

extension UIView {
    @discardableResult func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }
    @discardableResult func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.cornerRadius = self.layer.cornerRadius
        if let oldGradient = layer.sublayers?[0] as? CAGradientLayer {
            layer.replaceSublayer(oldGradient, with: gradient)
        } else {
            layer.insertSublayer(gradient, at: 0)
        }
        return gradient
    }
    
    func scaledBorderWidth(strength: CGFloat) -> CGFloat {
        let deviceMinWidth = CGFloat.minimum(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let viewMin = CGFloat.minimum(bounds.width, bounds.height)
        let normalized = CGFloat(viewMin / deviceMinWidth) * (strength * 2)
        return normalized
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        print("Could no create color from \(hex)")
        return nil
    }
}


