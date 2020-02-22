//
//  Projector.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2019/09/30.
//  Copyright © 2019 Spawn Camping Panda. All rights reserved.
//

import UIKit

class Projector {
    
    var displayWindow: UIWindow?
    //static let shared = Projector()
    private(set) lazy var screenBounds = displayWindow?.screen.bounds
    

    //MARK:- Public API
    var isCurrentlyPresenting: Bool {
        return displayWindow?.rootViewController != nil ? true : false
    }
    var isDisplayAvailable: Bool {
        return displayWindow != nil ? true : false
    }
    
    func cast(viewController: UIViewController) {
        if displayWindow != nil {
            displayWindow?.rootViewController = viewController
            displayWindow?.rootViewController?.view.alpha = 0
            displayWindow?.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.displayWindow?.rootViewController?.view.alpha = 1
            }
        }
    }
    
    func stopCasting() {
        displayWindow?.isHidden = true
        displayWindow?.rootViewController = nil
    }
    
    
    //MARK: - Private API
    private func checkForExternalDisplay() {
        let screens = UIScreen.screens
        guard screens.count > 1,  let screen = screens.last else { return }
        if displayWindow == nil {
            self.displayWindow = UIWindow(frame: screen.bounds)
            self.displayWindow!.screen = screen
        }
    }
    
    // We only need one instance of Projector
    private init() {
        NotificationCenter.default.addObserver(forName: UIScreen.didConnectNotification, object: nil, queue: nil) {
            [weak self] _ in
            print("HIIIIII")
            self?.checkForExternalDisplay()
        }
        
        NotificationCenter.default.addObserver(forName: UIScreen.didDisconnectNotification, object: nil, queue: nil) {
            [weak self] _ in
            print("BYEEEE")
            self?.displayWindow = nil
        }
        
        checkForExternalDisplay()
    }
}
