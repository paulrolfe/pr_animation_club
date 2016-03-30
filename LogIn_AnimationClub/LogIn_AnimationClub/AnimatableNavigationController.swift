//
//  AnimatableNavigationController.swift
//  LogIn_AnimationClub
//
//  Created by Paul Rolfe on 3/28/16.
//  Copyright © 2016 Paul Rolfe. All rights reserved.
//

import UIKit
import Intrepid

let CustomTransitionTime: NSTimeInterval = 0.5

class AnimatableNavigationController: UINavigationController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitioningDelegate = self
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = nil
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    @objc func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    @objc func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    @objc func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return CustomTransitionTime
    }
    
    @objc func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
            else {
                transitionContext.completeTransition(true)
                return
        }
        
        let containerView = transitionContext.containerView()
        containerView?.backgroundColor = WeirdGreen
        
        if let from = fromViewController as? AnimatableNavigationController {
            // Dismissing the nav
            let gradientMask = GradientView.fadedOutView()
            gradientMask.frame = toViewController.view.bounds
            gradientMask.transform = CGAffineTransformMakeTranslation(0, -fromViewController.view.bounds.height)
            
            let mask = UIView(frame: from.view.frame)
            mask.backgroundColor = UIColor.blackColor()
            
            let root = from.viewControllers.first as? LoggedInController
            
            containerView?.addSubview(toViewController.view)
            containerView?.addSubview(from.view)
            
            from.view.maskView = mask
            toViewController.view.maskView = gradientMask
            
            UIView.animateWithDuration(
                CustomTransitionTime,
                animations: {
                    gradientMask.transform = CGAffineTransformIdentity
                    mask.transform = CGAffineTransformMakeTranslation(0, from.view.frame.height)
                    root?.button.alpha = 0
                },
                completion: { _ in
                    toViewController.view.maskView = nil
                    from.view.maskView = nil
                    transitionContext.completeTransition(true)
                }
            )
        } else if let to = toViewController as? AnimatableNavigationController {
            // Presenting the nav
            let gradientMask = GradientView.fadedOutView()
            gradientMask.frame = fromViewController.view.bounds
            
            let mask = UIView(frame: to.view.frame)
            mask.backgroundColor = UIColor.blackColor()
            
            containerView?.addSubview(fromViewController.view)
            fromViewController.view.maskView = gradientMask
            to.view.maskView = mask
            containerView?.addSubview(to.view)
            mask.transform = CGAffineTransformMakeTranslation(0, to.view.bounds.height)
            let root = to.viewControllers.first as? LoggedInController
            to.navigationBarHidden = true
            root?.button.transform = CGAffineTransformMakeScale(0.5, 0.5)
            root?.button.alpha = 0
            
            UIView.animateWithDuration(
                CustomTransitionTime,
                animations: {
                    mask.transform = CGAffineTransformIdentity
                    gradientMask.transform = CGAffineTransformMakeTranslation(0, -fromViewController.view.bounds.height)
                    root?.navBackground.transform = CGAffineTransformMakeTranslation(0, -30)
                },
                completion: { _ in
                    to.navigationBarHidden = false
                    to.view.maskView = nil
                    fromViewController.view.maskView = nil
                    transitionContext.completeTransition(true)

                    UIView.animateSpringy(3) {
                        root?.navBackground.transform = CGAffineTransformIdentity
                    }
                }
            )
            // button stuff animates at slightly different rates
            UIView.animateSpringy(CustomTransitionTime + 3) {
                root?.button.alpha = 1.0
                root?.button.transform = CGAffineTransformIdentity
            }
        }
    }
}

private extension UIView {
    class func animateSpringy(duration: NSTimeInterval, animations: () -> ()) {
        UIView.animateWithDuration(
            duration,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 1.0,
            options: .CurveLinear,
            animations: animations,
            completion: nil
        )
    }
}

class GradientView: UIView {
    
    override class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }
    
    static func fadedOutView() -> GradientView {
        let view = GradientView()
        guard let colorLayer = view.layer as? CAGradientLayer else { return view }
        colorLayer.colors = [UIColor.blackColor().CGColor, UIColor.clearColor().CGColor]
        colorLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        return view
    }
}
