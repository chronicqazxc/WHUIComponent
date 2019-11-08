//
//  CircularViewControllerViewController.swift
//  WHUIComponents
//
//  Created by Wayne Hsiao on 2019/11/8.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit

class CircularViewControllerViewController: UIViewController, FloatingViewController {
    let windowWidth = CGFloat(100)
    @IBOutlet weak var floatingView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    weak var delegate: FloatingViewControllerDelegate?
    var originalOffset = CGSize.zero
    var dragOffset = CGSize.zero {
        didSet {
            relayout()
        }
    }
    var didInitializeRoundView = false
    override func viewDidLoad() {
        super.viewDidLoad()
        transitioningDelegate = FloatingViewIntegration.shared
        let longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(showSettings))
        view.addGestureRecognizer(longGestureRecognizer)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(toolbarPanned))
        view.addGestureRecognizer(panGestureRecognizer)
        floatingView.backgroundColor = .purple
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        relayout()
        layoutFloatingView()
    }
    
    func layoutFloatingView() {
        dragOffset = CGSize(width: UIScreen.main.bounds.size.width - windowWidth * 0.7,
                            height: windowWidth)
        clampDragOffset()
        floatingView.layer.cornerRadius = floatingView.frame.height / 2
        floatingView.clipsToBounds = false
        
        floatingView.layer.shadowColor = UIColor.systemGray.cgColor
        floatingView.layer.shadowOpacity = 1
        floatingView.layer.shadowOffset = CGSize.zero
        floatingView.layer.shadowRadius = 4
        floatingView.layer.shadowPath = UIBezierPath(roundedRect: floatingView.bounds, cornerRadius: floatingView.frame.height / 2).cgPath
    }
    
    func relayout() {
        guard let window = view.window else {
            return
        }
        window.clipsToBounds = true
        window.translatesAutoresizingMaskIntoConstraints = true
        window.frame = CGRect(x: dragOffset.width,
                              y: dragOffset.height,
                              width: windowWidth,
                              height: windowWidth)
        view.layoutIfNeeded()
    }
    
    @objc func showSettings(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard let entryViewController = delegate?.entryViewController?() else {
            return
        }
        entryViewController.transitioningDelegate = FloatingViewIntegration.shared
        present(entryViewController, animated: true, completion: nil)
    }
    
    @objc func toolbarPanned(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            originalOffset = dragOffset
        case .changed:
            let translation = gestureRecognizer.translation(in: self.view)
            dragOffset.height = originalOffset.height + translation.y
            dragOffset.width = originalOffset.width + translation.x
        default:
            UIView.animate(withDuration: 1.0,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 5,
                           options: .curveEaseInOut,
                           animations: {
                            self.clampDragOffset()
            }, completion: nil)
        }
    }
    
    func clampDragOffset() {
        let maxHiddenWidth = view.frame.size.width * 0.4
        if dragOffset.width < -maxHiddenWidth {
            dragOffset.width = -maxHiddenWidth
        } else if dragOffset.width > UIScreen.main.bounds.width - view.frame.size.width + maxHiddenWidth {
            dragOffset.width = UIScreen.main.bounds.width - view.frame.size.width + maxHiddenWidth
        }

        let maxHiddenHeight = view.frame.size.height * 0.4
        if dragOffset.height < -maxHiddenHeight {
            dragOffset.height = -maxHiddenHeight
        } else if dragOffset.height > UIScreen.main.bounds.height - view.frame.size.height + maxHiddenHeight {
            dragOffset.height = UIScreen.main.bounds.height - view.frame.size.height + maxHiddenHeight
        }
    }
     
    static func instanceFromStoryboard() -> FloatingViewController? {
        let bundle = Resource.bundle
        let storyboard = UIStoryboard(name: "Storyboard", bundle: bundle)
        let instance = storyboard.instantiateViewController(withIdentifier: "CircularViewControllerViewController")
        return instance as? CircularViewControllerViewController
    }
}
