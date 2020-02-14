//
//  Constraints.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/10.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class Constraints {
    enum Key: String {
        case iPhonePortrait, iPhoneLandscapeRegular, iPhoneLandscapeCompact, iPadAndExternalDisplays
    }
    /** The constraints for all iPhones in portrait mode (compact width, regular height).*/
    var iPhonePortrait: [NSLayoutConstraint]
    /** The constraints for larger iPhones in landscape mode (regular width and compact height). For example: iPhone Xs Max or iPhone 8+.*/
    var iPhoneLandscapeRegular: [NSLayoutConstraint]
    /** The constraints for smaller iPhones in landscape (compact width and compact height). For example: iPhone Xs or iPhone 8.*/
    var iPhoneLandscapeCompact: [NSLayoutConstraint]
    /** The constraints for iPad (regular width, regular height) and external displays.*/
    var iPadAndExternalDisplays: [NSLayoutConstraint]
    
    private var activeConstraints: [NSLayoutConstraint]?
    
    init(iPhonePortrait: [NSLayoutConstraint]? = nil, iPhoneLandscapeRegular: [NSLayoutConstraint]? = nil,
         iPhoneLandscapeCompact: [NSLayoutConstraint]? = nil, iPadAndExternalDisplays: [NSLayoutConstraint]? = nil)
    {
        self.iPhonePortrait = iPhonePortrait ?? []
        self.iPhoneLandscapeRegular = iPhoneLandscapeRegular ?? []
        self.iPhoneLandscapeCompact = iPhoneLandscapeCompact ?? []
        self.iPadAndExternalDisplays = iPadAndExternalDisplays ?? []
    }
    
    private init() {
        self.iPhonePortrait = []
        self.iPhoneLandscapeRegular = []
        self.iPhoneLandscapeCompact = []
        self.iPadAndExternalDisplays = []
    }
    
    func append(forSizeClass sizerClass: Constraints.Key, constraints: [NSLayoutConstraint]) {
        switch sizerClass {
        case .iPhonePortrait:
            constraints.forEach { iPhonePortrait.append($0) }
        case .iPhoneLandscapeRegular:
            constraints.forEach { iPhoneLandscapeRegular.append($0) }
        case .iPhoneLandscapeCompact:
            constraints.forEach { iPhoneLandscapeCompact.append($0) }
        case .iPadAndExternalDisplays:
            constraints.forEach { iPadAndExternalDisplays.append($0)}
        }
    }
    func append(forSizeClass sizerClass: Constraints.Key, constraints: NSLayoutConstraint...) {
        append(forSizeClass: sizerClass, constraints: constraints)
    }
    
    func activate(_ constraintsType: Key) {
        if let activeConstraints = activeConstraints {
            NSLayoutConstraint.deactivate(activeConstraints)
        }
        
        switch constraintsType {
        case .iPhonePortrait:
            guard !iPhonePortrait.isEmpty else {
                print(KBTError.constraintsNotSet(.iPhonePortrait).formatted)
                return
            }
            activeConstraints = iPhonePortrait
            
        case .iPhoneLandscapeRegular:
            guard !iPhoneLandscapeRegular.isEmpty else {
                print(KBTError.constraintsNotSet(.iPhoneLandscapeRegular).formatted)
                return
            }
            activeConstraints = iPhoneLandscapeRegular
            
        case .iPhoneLandscapeCompact:
            guard !iPhoneLandscapeCompact.isEmpty else {
                print(KBTError.constraintsNotSet(.iPhoneLandscapeCompact).formatted)
                return
            }
            activeConstraints = iPhoneLandscapeCompact
            
        case .iPadAndExternalDisplays:
            guard !iPadAndExternalDisplays.isEmpty else {
                print(KBTError.constraintsNotSet(.iPadAndExternalDisplays).formatted)
                return
            }
            activeConstraints = iPadAndExternalDisplays
        }
        NSLayoutConstraint.activate(activeConstraints!)
    }
}


