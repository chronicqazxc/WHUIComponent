//
//  ModelCoordinator.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/9/21.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation
import WHUIComponents

class ModelCoordinator: Coordinator {
    
    weak var navigationController: UINavigationController?
    var delegate: Coordinator?
    
    var viewController: UIViewController?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard var modelViewController = storyboard.instantiateViewController(withIdentifier: "ModelTableViewController") as? CoordinatorViewController & UIViewController else {
            return
        }
        modelViewController.coordinateDelegate = self
        navigationController?.pushViewController(modelViewController, animated: true)
    }
}

extension ModelCoordinator: CoordinatorViewContollerDelegate {
    func navigateToNextPage() {
        
    }
    
    func naviageBackToPreviousPage() {
        navigationController?.popViewController(animated: true)
    }
}
