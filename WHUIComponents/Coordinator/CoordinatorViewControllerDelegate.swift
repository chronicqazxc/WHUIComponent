//
//  CoordinatorViewControllerDelegate.swift
//  WHUIComponents
//
//  Created by Hsiao, Wayne on 2019/9/21.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation


/// Delegate manage havigation logic which invoked by view controllers, usually confirmed by coordinators.
public protocol CoordinatorViewContollerDelegate: class {
    func navigateToNextPage()
    func naviageBackToPreviousPage()
}
