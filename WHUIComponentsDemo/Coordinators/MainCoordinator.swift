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
    weak var delegate: Coordinator?
    private(set) var viewController: UIViewController?
    weak var navigationController: UINavigationController?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard var viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? CoordinatorViewController & UIViewController else {
            return
        }
        viewController.coordinateDelegate = self
        self.viewController = viewController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.viewControllers = [viewController]
    }
    
}

extension MainCoordinator: CoordinatorViewContollerDelegate {
    func navigateToNextPage(parameters: [AnyHashable: Any]?) {
        guard let navigationController = navigationController else {
            return
        }
        let manufacturerCoordinator = ManufacturerCoordinator(navigationController: navigationController)
        manufacturerCoordinator.delegate = self
        manufacturerCoordinator.start()
    }
    
    func naviageBackToPreviousPage() {
        
    }
}
