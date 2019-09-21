//
//  ManufacturerCoordinator.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/9/21.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation
import WHUIComponents

class ManufacturerCoordinator: Coordinator {
    
    var delegate: Coordinator?
    private(set) var viewController: UIViewController?
    weak var navigationController: UINavigationController?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard var manufacturerViewController = storyboard.instantiateViewController(withIdentifier: "ManufacturerTableViewController") as? CoordinatorViewController & UIViewController else {
            return
        }
        manufacturerViewController.coordinateDelegate = self
        navigationController?.pushViewController(manufacturerViewController, animated: true)
    }
}

extension ManufacturerCoordinator: CoordinatorViewContollerDelegate {
    func navigateToNextPage() {
        guard let navigationController = navigationController else {
            return
        }
        let modelCoordinator = ModelCoordinator(navigationController: navigationController)
        modelCoordinator.delegate = self
        modelCoordinator.start()
    }
    
    func naviageBackToPreviousPage() {
        navigationController?.popViewController(animated: true)
    }
}
