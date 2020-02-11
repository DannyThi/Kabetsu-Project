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
        case regular, horizontallyCompact, verticallyCompact
    }
    
    /** The constraints for sizeClass: Compact width and Regular height. For example: iPhones in portrait mode.*/
    var regular: [NSLayoutConstraint]
    
    /** The constraints for sizeClass: Compact width and Compact height. For example: iPhones in landscape mode.*/
    var horizontallyCompact: [NSLayoutConstraint]
    
    /** The constraints for sizeClass: Regular width and Regular height. For example: iPads in portrait or landscape  mode.*/
    var verticallyCompact: [NSLayoutConstraint]
    
    init(regular: [NSLayoutConstraint]? = nil, horizontallyCompact: [NSLayoutConstraint]? = nil,
         verticallyCompact: [NSLayoutConstraint]? = nil)
    {
        self.regular = regular ?? []
        self.horizontallyCompact = horizontallyCompact ?? []
        self.verticallyCompact = verticallyCompact ?? []
    }
    
    private init() {
        self.regular = []
        self.horizontallyCompact = []
        self.verticallyCompact = []
    }
    
    func activate(_ constraintsType: Key) {
        NSLayoutConstraint.deactivate(regular)
        NSLayoutConstraint.deactivate(horizontallyCompact)
        NSLayoutConstraint.deactivate(verticallyCompact)
        
        var selectedConstraints: [NSLayoutConstraint] = []
        
        switch constraintsType {
        case .regular:
            guard !regular.isEmpty else {
                print(KBTError.constraintsNotSet(.regular).formatted)
                return
            }
            selectedConstraints = regular
            
        case .horizontallyCompact:
            guard !horizontallyCompact.isEmpty else {
                print(KBTError.constraintsNotSet(.horizontallyCompact).formatted)
                return
            }
            selectedConstraints = horizontallyCompact
            
        case .verticallyCompact:
            guard !verticallyCompact.isEmpty else {
                print(KBTError.constraintsNotSet(.verticallyCompact).formatted)
                return
            }
            selectedConstraints = verticallyCompact
        }
        
        NSLayoutConstraint.activate(selectedConstraints)
    }
}


