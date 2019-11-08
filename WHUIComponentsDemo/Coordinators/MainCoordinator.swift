//
//  MainCoordinator.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/9/21.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation
import WHUIComponents

class MainCoordinator: Debug, Coordinator {
    
    var parameters: [AnyHashable : Any]?
    var delegate: CoordinatorDelegate?
    var coordinators = [Coordinator]()
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
        viewController = ViewController.instanceFromStoryboard()
        let viewModel = ViewControllerViewModel()
        viewModel.coordinator = self
        (viewController as? ViewController)?.viewModel = viewModel
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.viewControllers = [viewController!]
    }
}

extension MainCoordinator {
    func navigateToNextPage() {
        guard let navigationController = navigationController else {
            return
        }
        let manufacturerCoordinator = CarManufacturerCoordinator(navigationController: navigationController)
        manufacturerCoordinator.delegate = self
        manufacturerCoordinator.start()
        coordinators.append(manufacturerCoordinator)
    }
    
    func naviageBackToPreviousPage() {
        
    }
}

extension MainCoordinator: CoordinatorDelegate {
    func presentingFinished() {
        coordinators.removeLast()
    }
}
