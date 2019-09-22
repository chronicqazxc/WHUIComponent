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
    var modelViewController: ModelTableViewController? {
        return viewController as? ModelTableViewController
    }
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let manufacturer = parameters?[ManufacturerTableViewController.Constant.parameterKey] as? Manufacturer,
            let modelViewController = ModelTableViewController.initFromManufacturer(manufacturer) else {
                return
        }
        modelViewController.coordinateDelegate = self
        viewController = modelViewController
        navigationController?.pushViewController(modelViewController, animated: true)
    }
}

extension ModelCoordinator: CoordinatorViewContollerDelegate {
    func navigateToNextPage() {
        
        guard let selected = modelViewController?.modelViewModel.selectedData().first else {
            return
        }
        let alertController = UIAlertController(title: selected.title,
                                                message: selected.content,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(action)
        viewController?.present(alertController, animated: true)
    }
    
    func naviageBackToPreviousPage() {
        navigationController?.popViewController(animated: true)
    }
}
