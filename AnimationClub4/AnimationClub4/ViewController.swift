//
//  ViewController.swift
//  AnimationClub4
//
//  Created by Paul Rolfe on 1/8/16.
//  Copyright © 2016 Paul Rolfe. All rights reserved.
//

import UIKit
import IntrepidSwiftWisdom

class ViewController: UIViewController {
    
    @IBOutlet weak var bottomBackgroundView: CircleView!
    @IBOutlet weak var topBackgroundView: CircleView!
    @IBOutlet weak var mainImageView: CircleBorderImageView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var tweetButton: UIButton!
    
    var qp = QuoteProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Tap or swipe to move on.
        
        let tap = UITapGestureRecognizer(target: self, action: "next")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    dynamic private func next() {
        UIView.pa_percentAnimate(2, animation: positionViewsBasedOnAnimationState)
    }
    
    func positionViewsBasedOnAnimationState(state: AnimationState) {
        switch state {
        case .InProgress(let percent):
            print("percent done: \(percent)")
            loadNextData(true)
        default:
            break
        }
    }
    
    func loadNextData(_: Bool) {
        quoteLabel.alpha = 0
        bottomBackgroundView.alpha = 0
        bottomBackgroundView.center.y = 1000
        topBackgroundView.center.y = 1000
        
        let quote = qp.nextData()
        mainImageView.image = quote.image
        quoteLabel.text = quote.text
        
        UIView.animateWithDuration(1.0, animations: animateIn, completion: nil)
    }
    
    func animateIn() {
        // Just the movements, this is already inside of an animation
        quoteLabel.alpha = 1
        tweetButton.alpha = 1
        mainImageView.borderWidth = 5
        view.layoutIfNeeded()
    }
}

struct QuoteProvider {
    var count: Int = 0
    
    mutating func nextData() -> Quote {
        // Could actually provide data someday
        count += 1
        return data
    }
    
    mutating func lastData() -> Quote {
        count -= 1
        return data
    }
    
    var data: Quote {
        if count % 2 == 1 {
            return Quote(source: "Paul", image: UIImage(named: "paulrolfe_large")!, text: "I agree!")
        } else {
            return Quote(source: "Paul", image: UIImage(named: "Intrepid_logo")!, text: "What a fantastic app. Seriously, it's great.")
        }
    }
}

struct Quote {
    let source: String
    let image: UIImage
    let text: String
}
