//
//  LoggedInController.swift
//  LogIn_AnimationClub
//
//  Created by Paul Rolfe on 3/28/16.
//  Copyright © 2016 Paul Rolfe. All rights reserved.
//

import UIKit

class LoggedInController: UIViewController {
    
    let navBackground = UIView()
    let someLabel = UILabel()
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Back",
            style: .Plain,
            target: self,
            action: #selector(goBack)
        )
        view.backgroundColor = UIColor.whiteColor()
        title = "Dashboard"
        addFakeNavBackground()
        addLabel()
        addButton()
    }
    
    private func addFakeNavBackground() {
        navBackground.backgroundColor = WeirdGreen
        var size = navigationController?.navigationBar.frameSize
        size?.height = 128 // twice the regular size so it can bounce down.
        guard let adjustedSize = size else { return }
        
        // place it high so that it has room to bounce.
        navBackground.frame = CGRect(origin: CGPoint(x: 0, y: -64), size: adjustedSize)
        view.addSubview(navBackground)
    }
    
    private func addLabel() {
        someLabel.text = "This is just text to show the screen's positioning"
        someLabel.sizeToFit()
        someLabel.frameOrigin = CGPoint(x: 20, y: 200)
        view.addSubview(someLabel)
    }
    
    private func addButton() {
        button.backgroundColor = UIColor.greenColor()
        button.layer.cornerRadius = 30
        view.addSubview(button)
        button.constrainView(button, toWidth: 60)
        button.constrainView(button, toHeight: 60)
        view.constrainView(
            button,
            toInsets: UIEdgeInsets(
                top: CGFloat(NSNotFound),
                left: CGFloat(NSNotFound),
                bottom: 40,
                right: 40
            )
        )
    }
    
    dynamic private func goBack() {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
