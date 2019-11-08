//
//  Coordinator.swift
//  WHUIComponents
//
//  Created by Hsiao, Wayne on 2019/9/21.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation

/// Protocol for coordinator delegate.
public protocol CoordinatorDelegate: Coordinator {
    /// Coordinator is no needed.
    func presentingFinished()
}

/// Protocol for Coordinator pattern.
public protocol Coordinator: class {
    
    /// Parent coordinator.
    var delegate: CoordinatorDelegate? { get set }
    
    /// Child coordinators.
    var coordinators: [Coordinator] { get }
    
    /// Parameter dictionary used to present view controllers, usually provided by delegate(parent coordinator).
    var parameters: [AnyHashable: Any]? { get set }
    
    /// ViewController which be presenting.
    var viewController: UIViewController? { get }
    
    /// Coordinator initial method.
    ///
    /// - Parameter navigationController: NavigationController as view controllers container.
    init(navigationController: UINavigationController)
    
    /// Invoke this method to present new view controller.
    func start()
    
    /// Logic which navigate to next page.
    func navigateToNextPage()
    
    /// Logic which navigate to previous page.
    func naviageBackToPreviousPage()
}
