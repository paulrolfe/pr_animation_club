//
//  ViewController.swift
//  LogIn_AnimationClub
//
//  Created by Paul Rolfe on 3/28/16.
//  Copyright © 2016 Paul Rolfe. All rights reserved.
//

import UIKit

let WeirdGreen = UIColor(red:0.25, green:0.64, blue:0.62, alpha:1.00)

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        navigationController?.navigationBar.barTintColor = UIColor.clearColor()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        view.backgroundColor = WeirdGreen
        title = "Signing in..."
    }
    
    @IBAction func logInPressed(sender: UIButton) {
        let root = LoggedInController()
        let nav = AnimatableNavigationController(rootViewController: root)
        presentViewController(nav, animated: true, completion: nil)
    }
}

