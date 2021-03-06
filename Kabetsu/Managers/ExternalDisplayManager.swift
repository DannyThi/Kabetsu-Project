//
//  ExternalDisplayManager.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/21.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class ExternalDisplayManager: UIViewController {
    
    static let shared = ExternalDisplayManager()
    var rootViewController: UIViewController?
    
    override private init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configureNotificationListeners()
    }
    private init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func project(detailsViewController viewController: UIViewController) {
        guard UIScreen.screens.count > 1 else { return }
        guard rootViewController == nil else { endProjecting(); return }
        
        rootViewController = viewController
        self.addChild(viewController)
        viewController.didMove(toParent: self)
        viewController.view.alpha = 0
        self.view.addSubview(viewController.view)
        UIView.animate(withDuration: 0.3) {
            viewController.view.alpha = 1
        }
    }
    
    func endProjecting() {
        rootViewController?.view.removeFromSuperview()
        willMove(toParent: nil)
        rootViewController?.removeFromParent()
        rootViewController = nil
    }

}


// MARK: VIEW CONTROLLER LIFECYCLE

extension ExternalDisplayManager {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
}


// MARK: CONFIGURATION

extension ExternalDisplayManager {
    private func configureNotificationListeners() {
        NotificationCenter.default.addObserver(forName: UIScreen.didConnectNotification, object: nil, queue: nil) { _ in
            print("did connect")
        }
        NotificationCenter.default.addObserver(forName: UIScreen.didDisconnectNotification, object: nil, queue: nil) { _ in
            print("did disconnect")
        }
    }
    private func configureViewController() {
        view.backgroundColor = .systemBackground
    }
}


