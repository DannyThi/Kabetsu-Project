//
//  ExternalSceneDelegate.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/25.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class ExternalSceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        #warning("TODO: - DEFAULT COLORS WILL NEED TO BE SET HERE I THINK")
        // MAY NEED TO REFACTOR AND INHERIT CODE
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = configureExternalDisplayManager()
        window?.isHidden = false
        
        setUserInterfaceStyle()
    }
    
    private func configureExternalDisplayManager() -> UINavigationController {
        let navCon = UINavigationController(rootViewController: ExternalDisplayManager.shared)
        navCon.navigationBar.isHidden = true
        return navCon
    }
    
    private func setUserInterfaceStyle() {
        let settings = Settings.shared
        settings.updateUserInterfaceStyle(settings.interfaceStyle)
    }
    
}
