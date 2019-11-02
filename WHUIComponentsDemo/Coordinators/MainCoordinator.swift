//
//  MainCoordinator.swift
//  WHUIComponentsDemo
//
//  Created by Hsiao, Wayne on 2019/9/21.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation
import WHUIComponents

class MainCoordinator: Coordinator {
    
    var parameters: [AnyHashable : Any]?
    weak var delegate: CoordinatorDelegate?
    var coordinators = [Coordinator]()
    weak private(set) var viewController: UIViewController?
    weak var navigationController: UINavigationController?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
            return
        }
        let viewModel = ViewControllerViewModel()
        viewModel.coordinateDelegate = self
        viewController.viewModel = viewModel
        self.viewController = viewController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.viewControllers = [viewController]
    }
}

extension MainCoordinator {
    func navigateToNextPage() {
        guard let navigationController = navigationController else {
            return
        }
        let manufacturerCoordinator = ManufacturerCoordinator(navigationController: navigationController)
        manufacturerCoordinator.delegate = self
        manufacturerCoordinator.start()
        coordinators.append(manufacturerCoordinator)
    }
    
    func naviageBackToPreviousPage() {
        
    }
}

extension MainCoordinator: CoordinatorDelegate {
    func finish() {
        coordinators.removeLast()
    }
}
