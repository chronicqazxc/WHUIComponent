//
//  Debug.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/11/2.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation
import WHUIComponents

class Debug: NSObject {
    deinit {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else {
            return
        }
        let alertController = UIAlertController(title: String(describing: self), message: #function, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            appDelegate.presentNextAlertController()
        })
        alertController.addAction(alertAction)
        appDelegate.presentAlertController(alertController)
    }
}
