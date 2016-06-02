//
//  ViewController.swift
//  AnimationClub_Tableview
//
//  Created by Paul Rolfe on 5/23/16.
//  Copyright © 2016 Paul Rolfe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: TopFadingScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scrollView.views = randomViews()
    }

    private func randomViews() -> [UIView] {
        var viewArray: [UIView] = []
        let viewFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 140)
        for i in 0..<10 {
            let view = UIView(frame: viewFrame)
            view.backgroundColor = UIColor(white: (CGFloat(i) / CGFloat(10)), alpha: 1)
            view.layer.borderWidth = 5
            view.layer.borderColor = UIColor.whiteColor().CGColor
            viewArray.append(view)
        }
        return viewArray
    }
}

