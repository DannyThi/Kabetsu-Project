//
//  KBTError.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/11.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import Foundation

enum KBTError {
    case constraintsNotSet(Constraints.Key)
    case delegateNotSet(String)
    
    var formatted: String {
        switch self {
        case .constraintsNotSet(let constraintType):
            return "Layout constraints not set for **\(constraintType)**."
        case .delegateNotSet(let classNameAndFunction):
            return "Delegate not set for **\(classNameAndFunction)**."
        }
    }
}
