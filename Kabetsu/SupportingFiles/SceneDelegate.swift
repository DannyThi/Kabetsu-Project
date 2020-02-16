//
//  SceneDelegate.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/27.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private var tabItemCount = 0

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        setGlobalAppTint(.systemGreen)

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = createTabBarController()
        window?.makeKeyAndVisible()
        
        setUserInterfaceStyle()
    }
    
    private func setGlobalAppTint(_ tint: UIColor) {
        UITabBar.appearance().tintColor = tint
        UINavigationBar.appearance().tintColor = tint
        UIButton.appearance().tintColor = tint
    }
    
    private func createTabBarController() -> UITabBarController {
        let tabBar = UITabBarController()
        tabBar.viewControllers = [createCountdownTimerVC()]
        return tabBar
    }
    
    private func createCountdownTimerVC() -> UINavigationController {
        let tabImage = UIImage(systemName: "timer", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        let tab = UITabBarItem(title: "Timers", image: tabImage, tag: tabItemCount)
        let navCon = UINavigationController(rootViewController: TimersListVC())
        navCon.navigationBar.prefersLargeTitles = true
        navCon.tabBarItem = tab
        tabItemCount += 1
        
        return navCon
    }
    
    private func setUserInterfaceStyle() {
        let settings = Settings.shared
        settings.updateUserInterfaceStyle(settings.interfaceStyle)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

