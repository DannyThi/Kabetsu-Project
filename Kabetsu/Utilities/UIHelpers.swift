//
//  UIHelpers.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/28.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class UIHelpers {
    
    static let cornerRadius: CGFloat = 25
    static let borderWidth: CGFloat = 2
    static let digitalDisplayFontHeightToWidthRatio: CGFloat = 0.17
    
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

    case dismiss = "xmark.circle.fill"
    case done = "checkmark.circle.fill"
    case project = "tv.circle.fill"

    var image: UIImage {
        return UIImage(systemName: self.rawValue, withConfiguration: GlobalImageKeys.symbolConfig())!
    }
}


