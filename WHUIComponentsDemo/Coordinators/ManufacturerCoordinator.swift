//
//  ManufacturerCoordinator.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/9/21.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation
import WHUIComponents

class ManufacturerCoordinator: CoordinatorDebug, Coordinator {

    var parameters: [AnyHashable : Any]?
    var delegate: CoordinatorDelegate?
    var coordinators = [Coordinator]()
    private(set) var viewController: UIViewController?
    weak var navigationController: UINavigationController?
    
    required init() {
        super.init()
    }
    
    required convenience init(navigationController: UINavigationController) {
        self.init()
        self.navigationController = navigationController
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let manufacturerViewController = storyboard.instantiateViewController(withIdentifier: "ManufacturerTableViewController") as? ManufacturerTableViewController else {
            return
        }

        let viewModel = ManufacturerViewModel()
        viewModel.coordinator = self
        
        manufacturerViewController.viewModel = viewModel
        
        navigationController?.pushViewController(manufacturerViewController, animated: true)
        viewController = manufacturerViewController
    }
}

extension ManufacturerCoordinator {
    func navigateToNextPage() {
        guard let navigationController = navigationController,
            let manufacturerViewController = viewController as? ManufacturerTableViewController else {
            return
        }
        let viewModel = manufacturerViewController.viewModel
        let manufacture = viewModel!.selectedData().first as! Manufacturer
        
        let modelCoordinator = ModelCoordinator(navigationController: navigationController)
        modelCoordinator.delegate = self
        modelCoordinator.parameters = [ManufacturerTableViewController.Constant.parameterKey: manufacture]
        modelCoordinator.start()
        coordinators.append(modelCoordinator)
    }
    
    func naviageBackToPreviousPage() {
        guard let toViewController = delegate?.viewController else {
            return
        }
        navigationController?.popToViewController(toViewController, animated: true)
        delegate?.finish()
    }
}

extension ManufacturerCoordinator: CoordinatorDelegate {
    func finish() {
        coordinators.removeLast()
    }
}
