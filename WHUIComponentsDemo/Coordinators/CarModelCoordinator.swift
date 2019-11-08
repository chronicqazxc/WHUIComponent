//
//  CarModelCoordinator.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/9/21.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation
import WHUIComponents

class CarModelCoordinator: Debug, Coordinator {
    var parameters: [AnyHashable : Any]?
    
    weak var navigationController: UINavigationController?
    var delegate: CoordinatorDelegate?
    var coordinators = [Coordinator]()
    
    var viewController: UIViewController?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let manufacturer = parameters?[CarManufacturerTableViewController.Constant.parameterKey] as? CarManufacturer else {
                return
        }
        let viewModel = CarModelViewModel(manufacturer: manufacturer)
        viewModel.coordinator = self
        
        guard let modelViewController = CarModelTableViewController.instanceWith(viewModel: viewModel) else {
            return
        }
        modelViewController.viewModel = viewModel

        navigationController?.pushViewController(modelViewController, animated: true)
        viewController = modelViewController
    }
}

extension CarModelCoordinator {
    func navigateToNextPage() {

        guard let viewController = viewController as? CarModelTableViewController,
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
        delegate?.presentingFinished()
    }
}

extension CarModelCoordinator: CoordinatorDelegate {
    func presentingFinished() {
        coordinators.removeLast()
    }
}
