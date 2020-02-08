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
    
    static func displayDefaultAlert(title: String? = nil, message: String? = nil, actions: [UIAlertAction], completed: (() ->Void)? = nil) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            ac.addAction(action)
        }
        let presentingVC = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController
        presentingVC?.present(ac, animated: true, completion: completed)
    }
    
}


class Constraints {
    enum ConstraintsKey {
        case iPhonePortrait, iPhoneLandscape, iPadPortrait, iPadLandscape
    }
    
    var iPhonePortrait: [NSLayoutConstraint] = []
    var iPhoneLandscape: [NSLayoutConstraint] = []
    var iPadPortrait: [NSLayoutConstraint] = []
    var iPadLandscape: [NSLayoutConstraint] = []
    
    init(iPhonePortrait: [NSLayoutConstraint]? = nil, iPhoneLandscape: [NSLayoutConstraint]? = nil,
         iPadPortrait: [NSLayoutConstraint]? = nil, iPadLandscape: [NSLayoutConstraint]? = nil) {
        
        if iPhonePortrait != nil { self.iPhonePortrait = iPhonePortrait! }
        if iPhoneLandscape != nil { self.iPhoneLandscape = iPhoneLandscape! }
        if iPadPortrait != nil { self.iPadPortrait = iPadPortrait! }
        if iPadLandscape != nil { self.iPadLandscape = iPadLandscape! }
    }
    
    func activate(_ constraintsType: ConstraintsKey) {
        NSLayoutConstraint.deactivate(iPhonePortrait)
        NSLayoutConstraint.deactivate(iPhoneLandscape)
        NSLayoutConstraint.deactivate(iPadPortrait)
        NSLayoutConstraint.deactivate(iPadLandscape)
        
        var selectedConstraints: [NSLayoutConstraint]
        switch constraintsType {
        case .iPhonePortrait:
            guard !iPhonePortrait.isEmpty else {
                print("Layout constraint not set for \(ConstraintsKey.iPhonePortrait)");
                return
            }
            selectedConstraints = iPhonePortrait
            
        case .iPhoneLandscape:
            guard !iPhoneLandscape.isEmpty else {
                print("Layout constraint not set for \(ConstraintsKey.iPhoneLandscape)");
                return
            }
            selectedConstraints = iPhoneLandscape
            
        case .iPadPortrait:
            guard !iPadPortrait.isEmpty else {
                print("Layout constraint not set for \(ConstraintsKey.iPadPortrait)");
                return
            }
            selectedConstraints = iPadPortrait

        case .iPadLandscape:
            guard !iPadLandscape.isEmpty else {
                print("Layout constraint not set for \(ConstraintsKey.iPadLandscape)");
                return
            }
            selectedConstraints = iPadLandscape
        }
        
        NSLayoutConstraint.activate(selectedConstraints)
    }
}
