//
//  ViewController.swift
//  navigation-title
//
//  Created by Paul Rolfe on 2/17/16.
//  Copyright © 2016 Paul Rolfe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        label.text = "Move this label"
        navigationItem.titleView = label
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        guard
            let navTitle = navigationItem.titleView
            else { return }
        
        guard let convertedFrame = navTitle.superview?.convertRect(navTitle.frame, toView: view) else { return }
        navTitle.removeFromSuperview()
        navTitle.frame = convertedFrame
        print("\(convertedFrame)")
        navigationController?.view.addSubview(navTitle)
        navigationController?.view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.5, animations: {
            navTitle.frame = CGRect(x: 160, y: 200, width: convertedFrame.width, height: convertedFrame.height)
            }, completion: { _ in
                print(navTitle.frame)
        })
    }
}

