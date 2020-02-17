//
//  AlertHandler.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/17.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

// We need to display an alert on all screens
// sound the alarm
// buzz when not displaying.

// alerts need to be set up on individual screens?

class AlertHandler {
    
    static let shared = AlertHandler()
    
    private init() {}
    
    func fireAlert(onViewController viewController: UIViewController) {
        let alert = KBTAlertController(withTitle: "TEST", message: "Message")
        viewController.present(alert, animated: true)
    }
}



// MARK: - ACTIONS

extension AlertHandler {
    
}



// MARK: - CONFIGURATION

extension AlertHandler {
    
    
}



// MARK: - CONSTRAINTS

extension AlertHandler {
    
    
}
