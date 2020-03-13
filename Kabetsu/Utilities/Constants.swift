//
//  UIHelpers.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/28.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

struct KBTColors {
    static let primaryLabel = UIColor(named: "primaryLabel")
    static let secondaryLabel = UIColor(named: "secondaryLabel")
    static let kabetsuGreen = UIColor(named: "kabetsuGreen")
    static let kabetsuGreenBorder = UIColor(named: "kabetsuGreenBorder")
}

class Constants {
    struct Gradient {
        static let green = [UIColor(red: 48 / 255, green: 209 / 255, blue: 88 / 255, alpha: 1),
                            UIColor(red: 31 / 255, green: 156 / 255, blue: 62 / 255, alpha: 1)]
    }
    
    struct ViewAppearance {
        static let cornerRadius: CGFloat = 25
        static var borderWidth: CGFloat { return UITraitCollection.current.userInterfaceStyle == .dark ? 3 : 0 }
        static var shadowOpacity: Float { return UITraitCollection.current.userInterfaceStyle == .dark ? 0 : 0.5 }
        static let digitalDisplayFontHeightToWidthRatio: CGFloat = 0.17
    }
}

class UIHelpers {
    static func displayDefaultAlert(title: String? = nil, message: String? = nil, actions: [UIAlertAction], completed: (() ->Void)? = nil) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            ac.addAction(action)
        }
        let presentingVC = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController
        presentingVC?.present(ac, animated: true, completion: completed)
    }
}

enum GlobalImageKeys: String, CaseIterable {
    typealias RawValue = String
    static func symbolConfig(pointSize: CGFloat? = 20) -> UIImage.SymbolConfiguration {
        return UIImage.SymbolConfiguration(pointSize: pointSize!, weight: .medium)
    }

    case dismissFill = "xmark.circle.fill"
    case dismiss = "xmark"
    case done = "checkmark.circle.fill"
    case project = "tv.circle.fill"
    case reset = "arrow.counterclockwise"
    case play = "play"
    case pause = "pause"
    case log = "square.and.pencil"
    case settings = "slider.horizontal.3"
    

    var image: UIImage {
        return UIImage(systemName: self.rawValue, withConfiguration: GlobalImageKeys.symbolConfig())!
    }
}


