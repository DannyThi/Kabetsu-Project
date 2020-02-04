//
//  UIHelpers.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/28.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class UIHelpers {
    
    static let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)

    static func getFlowLayout(in view: UIView, noOfColumns: Int) -> UICollectionViewFlowLayout {
        let columns = CGFloat(noOfColumns)
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth: CGFloat = width - (padding * 2) - (minimumItemSpacing * (columns - 1))
        let itemWidth: CGFloat = availableWidth / columns
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth * 0.8)
        
        return flowLayout
    }
    
    static func displayDefaultAlert(title: String? = nil, message: String? = nil, actions: [UIAlertAction], completed: (() ->Void)? = nil) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            ac.addAction(action)
        }
        let presentingVC = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController
        presentingVC?.present(ac, animated: true, completion: completed)
    }
    
}
