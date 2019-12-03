//
//  SceneDelegate.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/12/3.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit
import WHUIComponents

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var rootCoordinate: Coordinator!
    var window: UIWindow?
    private var alertControllers = Stack<UIAlertController>()
    
    func presentAlertController(_ alertController: UIAlertController) {
        if let _ = window!.rootViewController?.presentedViewController as? UIAlertController {
            alertControllers.push(alertController)
        } else {
            window!.rootViewController?.present(alertController, animated: true)
        }
    }
    
    func presentNextAlertController() {
        guard let alertController = alertControllers.pop() else {
            return
        }
        window!.rootViewController?.present(alertController, animated: true)
    }
    
    // UIWindowScene delegate
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // If there were no user activities, we don't have to do anything.
        // The `window` property will automatically be loaded with the storyboard's initial view controller.
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = UINavigationController()
        window?.makeKeyAndVisible()
        rootCoordinate = MainCoordinator(navigationController: window?.rootViewController as! UINavigationController)
        rootCoordinate.start()
    }
  
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return scene.userActivity
    }
}
