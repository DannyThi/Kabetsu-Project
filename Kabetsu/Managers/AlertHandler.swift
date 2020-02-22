//
//  AlertHandler.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/17.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

#warning("TODO: - VIBRATE ON ALERT")
#warning("TODO: - PROJECT SCREEN")
#warning("TODO: - BLUR BACKGROUND ON ALERT")
#warning("TODO: - SOUND ON ALERT")
#warning("TODO: - ")


// auxilary alert should be dismissed via notificaitons


class AlertHandler {
    
    static let shared = AlertHandler()
    
    private init() {}
    
    
    //#warning("Might be best to let the view controllers handle alerts. this handler can just broadcast, and all listeners can tune in")
//    func fireAlert(onViewController viewController: UIViewController) {
//        let alert = KBTAlertController(withTitle: "TIME UP!", message: "Timer completed.")
//        viewController.present(alert, animated: true)
//    }
    
    private func fireAuxilaryAlert() {
        
    }
}



// MARK: - ACTIONS

extension AlertHandler {
    
}



// MARK: - CONFIGURATION

extension AlertHandler {
    private func configureNotificationHandlers() {
        
    }
    
}



// MARK: - CONSTRAINTS

extension AlertHandler {
    
    
}
