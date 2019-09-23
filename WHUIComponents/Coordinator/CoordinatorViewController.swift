//
//  CoordinatorViewController.swift
//  WHUIComponents
//
//  Created by Hsiao, Wayne on 2019/9/21.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation

/// ViewControllers who confirm this protocol to has the ability to invoke coordinateDelegate.
public protocol CoordinatorViewController {
    var coordinateDelegate: CoordinatorViewContollerDelegate? { get set }
}
