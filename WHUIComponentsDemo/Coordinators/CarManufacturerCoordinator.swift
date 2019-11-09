//
//  ManufacturerCoordinator.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/9/21.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation
import WHUIComponents

class CarManufacturerCoordinator: Debug, Coordinator {
    var parameters: [AnyHashable : Any]?
    var delegate: CoordinatorDelegate?
    var coordinators = [AnyHashable: Coordinator]()
    private(set) var viewController: UIViewController?
    weak var navigationController: UINavigationController?
    
    required override init() {
        super.init()
    }
    
    required convenience init(navigationController: UINavigationController) {
        self.init()
        self.navigationController = navigationController
    }
    
    func start() {
        let carManufactureViewController = CarManufacturerTableViewController.instanceFromStoryboard()

        let viewModel = CarManufacturerViewModel()
        viewModel.coordinator = self
        
        carManufactureViewController.viewModel = viewModel
        
        navigationController?.pushViewController(carManufactureViewController, animated: true)
        viewController = carManufactureViewController
    }
}

extension CarManufacturerCoordinator {
    func navigateForwardToNextPage() {
        guard let navigationController = navigationController,
            let manufacturerViewController = viewController as? CarManufacturerTableViewController else {
            return
        }
        let viewModel = manufacturerViewController.viewModel
        let manufacture = viewModel!.selectedData().first as! CarManufacturer
        
        let modelCoordinator = CarModelCoordinator(navigationController: navigationController)
        modelCoordinator.delegate = self
        modelCoordinator.parameters = [CarManufacturerTableViewController.Constant.parameterKey: manufacture]
        modelCoordinator.start()
        coordinators["CarModelCoordinator"] = modelCoordinator
    }
    
    func naviageBackToPreviousPage() {
        guard let toViewController = delegate?.viewController else {
            return
        }
        navigationController?.popToViewController(toViewController, animated: true)
        delegate?.presentingFinished()
    }
}

extension CarManufacturerCoordinator: CoordinatorDelegate {
    func presentingFinished() {
        coordinators.removeValue(forKey: "CarModelCoordinator")
    }
}
