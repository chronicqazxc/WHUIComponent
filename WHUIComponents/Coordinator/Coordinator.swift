//
//  Coordinator.swift
//  WHUIComponents
//
//  Created by Hsiao, Wayne on 2019/9/21.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation

public protocol Coordinator: class {
    var delegate: Coordinator? { get set }
    var parameters: [AnyHashable: Any]? { get set }
    var viewController: UIViewController? { get }
    init(navigationController: UINavigationController)
    func start()
}
