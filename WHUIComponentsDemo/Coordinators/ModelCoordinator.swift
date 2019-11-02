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
    var delegate: CoordinatorDelegate?
    var coordinators = [Coordinator]()
    
    var viewController: UIViewController?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let manufacturer = parameters?[ManufacturerTableViewController.Constant.parameterKey] as? Manufacturer else {
                return
        }
        let viewModel = ModelViewModel(manufacturer: manufacturer)
        viewModel.coordinator = self
        guard let modelViewController = ModelTableViewController.instanceWith(viewModel: viewModel) else {
            return
        }
        viewController = modelViewController
        navigationController?.pushViewController(modelViewController, animated: true)
    }
}

extension ModelCoordinator {
    func navigateToNextPage() {

        guard let viewController = viewController as? ModelTableViewController,
            let selected = viewController.viewModel?.selectedData().first else {
            return
        }
        let alertController = UIAlertController(title: "Dear guest",
                                                message: "You selected the \(selected.title) - \(selected.content)",
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(action)
        viewController.present(alertController, animated: true)
    }
    
    func naviageBackToPreviousPage() {
        guard let toViewController = delegate?.viewController else {
            return
        }
        navigationController?.popToViewController(toViewController, animated: true)
        delegate?.finish()
    }
}

extension ModelCoordinator: CoordinatorDelegate {
    func finish() {
        coordinators.removeLast()
    }
}
