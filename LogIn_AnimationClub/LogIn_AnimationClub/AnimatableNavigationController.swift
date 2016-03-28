//
//  AnimatableNavigationController.swift
//  LogIn_AnimationClub
//
//  Created by Paul Rolfe on 3/28/16.
//  Copyright © 2016 Paul Rolfe. All rights reserved.
//

import UIKit

let CustomTransitionTime: NSTimeInterval = 0.5

class AnimatableNavigationController: UINavigationController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = WeirdGreen
        navigationBar.barTintColor = WeirdGreen
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        view.backgroundColor = UIColor.whiteColor()
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
        
        
        if fromViewController == self {
            // Dismissing the nav

            
            // linear to keep the nav bar in line with the gesture
            UIView.animateWithDuration(
                CustomTransitionTime,
                delay: 0,
                options: .CurveEaseInOut,
                animations: {

                },
                completion: { _ in
                    transitionContext.completeTransition(true)
                }
            )
        } else {
            // Presenting the nav

            
            UIView.animateWithDuration(
                CustomTransitionTime,
                animations: {

                },
                completion: { _ in
                    transitionContext.completeTransition(true)
                }
            )
        }
    }
}