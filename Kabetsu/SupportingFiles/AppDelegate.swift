//
//  AppDelegate.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/27.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        var sceneName: String
        var delegateClass: AnyClass
        switch connectingSceneSession.role {
        case .windowExternalDisplay:
            sceneName = "External Configuration"
            delegateClass = ExternalSceneDelegate.classForCoder()
        default:
            sceneName = "Default Configuration"
            delegateClass = SceneDelegate.classForCoder()
        }
        
        let sceneConfiguration = UISceneConfiguration(name: sceneName, sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = delegateClass
        return sceneConfiguration
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

