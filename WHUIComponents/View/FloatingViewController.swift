//
//  FloatingViewController.swift
//  WHUIComponents
//
//  Created by Wayne Hsiao on 2019/11/8.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit


/// Floating view delegate.
public protocol FloatingViewControllerDelegate: class {
    
    /// Arbitrary view controller will be presented by floating view.
    var entryViewController: (() -> UIViewController)? { get set }
}

protocol FloatingViewController: UIViewController {
    static func instanceFromStoryboard() -> FloatingViewController?
    var floatingView: UIView! { get set }
    var delegate: FloatingViewControllerDelegate? { get set }
}
