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
    var parameters: [AnyHashable : Any]?
    
    weak var navigationController: UINavigationController?
    var delegate: Coordinator?
    
    var viewController: UIViewController?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let manufacturer = parameters?[ManufacturerTableViewController.Constant.parameterKey] as? Manufacturer,
            let modelViewController = ModelTableViewController.initFromManufacturer(manufacturer) else {
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
