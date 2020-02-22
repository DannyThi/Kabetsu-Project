//
//  ExternalDisplayManager.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/21.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit



// this will attach itself to the externalscreen
//

class ExternalDisplayManager: UIViewController {
    
    static let shared = ExternalDisplayManager()
    
    static var isCurrentlyPresenting: Bool = false
    var detailViewController: UIViewController?
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configureNotificationListeners()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    
    
    
    // screen comes before window
    // THE UISCREEN OBJECT IS THE SCREEN OF THE DEVICE.
    // A UIWINDOW OBJECT IS THE VIEW FOR THE SCREEN.
//    func getExternalWindow(windowScene: UIWindowScene) {
//        let windows = windowScene.windows
//        guard windows.count > 1, let window = windows.last else { return }
//
////        let window = UIWindow(frame: screen.bounds)
////        window.screen = screen
////
////        window.rootViewController = self
////        return window
//    }
    
    func displayDetailView() {
        print("HI")
//        self.addChild(detailViewController!)
//        self.view = detailViewController?.view
//
    }
    
    private func configureExternalDisplay(screen: UIScreen) {
        print("Got a screen")
        var window = UIWindow(frame: screen.bounds)
        
        window.screen = screen
        window.rootViewController = self
        window.isHidden = false
    }
}


// MARK: VIEW CONTROLLER LIFECYCLE

extension ExternalDisplayManager {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")
        view.backgroundColor = .systemRed
    }
}

// MARK: CONFIGURATION

extension ExternalDisplayManager {
    private func configureNotificationListeners() {
        NotificationCenter.default.addObserver(forName: UIScreen.didConnectNotification, object: nil, queue: nil) {
            [weak self] notififcation in
            guard let screen = notififcation.object as? UIScreen else { return }
            self?.configureExternalDisplay(screen: screen)
        }
        NotificationCenter.default.addObserver(forName: UIScreen.didDisconnectNotification, object: nil, queue: nil) { _ in
            print("did disconnect")
        }
    }
    private func configureViewController() {
        
    }
}


