//
//  FloatingViewIntegration.swift
//  WHUIComponents
//
//  Created by Wayne Hsiao on 2019/11/8.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit

/// FloatingViewIntegration will generate a new window in status bar level, and generate a view in the window, the floating view, it wouldn't been blocked by any view from the window of application delegate.
/// FloatingViewIntegration also give the entry view from the developer to the floating view.
public final class FloatingViewIntegration: NSObject, FloatingViewControllerDelegate {
    
    /// Designated initializer.
    public static let shared = FloatingViewIntegration()

    fileprivate var floatingViewController: FloatingViewController = CircularViewControllerViewController.instanceFromStoryboard()!
    
    /// Entry view controller, should be provided by the developer. While user long pressed the floating view, it will present the entry view.
    public var entryViewController: (() -> UIViewController)?
    
    fileprivate var previousFrame = CGRect.zero
    
    /// Show the floating view.
    public func showFloatingView() {
        self.window?.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.window?.alpha = 1
        })
    }
    
    /// Hide the floating view.
    public func hideFloatingView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.window?.alpha = 0
        }) { (_) in
            self.window?.isHidden = true
        }
    }
    
    fileprivate lazy var window: UIWindow? = {
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                let window = UIWindow(frame: .zero)
                configWindow(window)
                return window
            }
            let window = UIWindow(windowScene: windowScene)
            configWindow(window)
            return window
        } else {
            let window = UIWindow(frame: .zero)
            configWindow(window)
            return window
        }
    }()
    
    fileprivate func configWindow(_ window: UIWindow) {
        window.windowLevel = UIWindow.Level.statusBar
        floatingViewController.delegate = self
        window.rootViewController = floatingViewController
        window.alpha = 0
        window.isHidden = true
    }
}

extension FloatingViewIntegration: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
         return FadePushAnimation()
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadePopAnimation()
    }
}

class FadePushAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let fromSnapshot = fromViewController.view.snapshotView(afterScreenUpdates: true),
            let toViewController = transitionContext.viewController(forKey: .to)
            else {
                return
        }

        transitionContext.containerView.addSubview(toViewController.view!)
        transitionContext.containerView.addSubview(fromSnapshot)
        fromViewController.view.alpha = 0
        toViewController.view.alpha = 0
        
        FloatingViewIntegration.shared.previousFrame = transitionContext.containerView.window!.frame
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(
          withDuration: duration,
          delay: 0,
          options: .calculationModeCubic,
          animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/2) {
                fromSnapshot.alpha = 0
            }
            UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2) {
                toViewController.view.window?.frame = UIScreen.main.bounds
                toViewController.view.alpha = 1
            }
        },
          completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromViewController.view.alpha = 1
        })
    }
}

class FadePopAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let fromSnapshot = fromViewController.view.snapshotView(afterScreenUpdates: true),
            let toViewController = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        toViewController.view.alpha = 0
        fromViewController.view.alpha = 0
        transitionContext.containerView.addSubview(fromSnapshot)
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            fromSnapshot.frame = FloatingViewIntegration.shared.previousFrame
            fromSnapshot.layer.cornerRadius = FloatingViewIntegration.shared.previousFrame.height / 2
            fromSnapshot.clipsToBounds = true
            fromSnapshot.alpha = 0.5
        }, completion: { _ in
            toViewController.view.window?.frame = FloatingViewIntegration.shared.previousFrame
            UIView.animate(withDuration: duration, animations: {
                toViewController.view.alpha = 1
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        })
    }
    
    func centerOf(rect: CGRect) -> CGPoint {
        return CGPoint(x: rect.midX, y: rect.midY)
    }
    
    func zeroRectBy(position: CGPoint) -> CGRect {
        return CGRect(x: position.x, y: position.y, width: 0, height: 0)
    }
}
