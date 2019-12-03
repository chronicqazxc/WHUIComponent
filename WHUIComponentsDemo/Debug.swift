//
//  Debug.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/11/2.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit
import WHUIComponents

class Debug: NSObject {
    deinit {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate else {
            return
        }
        let alertController = UIAlertController(title: String(describing: self), message: #function, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            sceneDelegate.presentNextAlertController()
        })
        alertController.addAction(alertAction)
        sceneDelegate.presentAlertController(alertController)
    }
}
