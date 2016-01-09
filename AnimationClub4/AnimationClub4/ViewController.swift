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
        // TODO:Add pan to begin animation. Pan just moves up bottom view.
        
        let tap = UITapGestureRecognizer(target: self, action: "next")
        view.addGestureRecognizer(tap)
    }
    
    dynamic private func next() {
        UIView.animateWithDuration(0.5, animations: animateOut, completion: loadNextData)
    }
    
    func animateOut() {
        // Just the movements, this is already inside of an animation
        bottomBackgroundView.center.y = topBackgroundView.center.y
        mainImageView.borderWidth = mainImageView.radius
        tweetButton.center.y -= 20
        tweetButton.alpha = 0
    }
    
    func loadNextData(_: Bool) {
        let quote = qp.nextData()
        mainImageView.image = quote.image
        quoteLabel.text = quote.text
        
        // setting positions for animation back in.
        quoteLabel.alpha = 0
        bottomBackgroundView.center.y = 1.5 * bottomBackgroundView.bounds.height
        topBackgroundView.center.y = 1.5 * topBackgroundView.bounds.height
        tweetButton.center.y = view.bounds.height
        quoteLabel.center.y += 100
        mainImageView.borderWidth = mainImageView.radius
        mainImageView.alpha = 0
        
        UIView.animateWithDuration(1.0, delay: 0, options: .CurveEaseOut, animations: animateInQuote, completion: nil)
        UIView.animateWithDuration(1.0, delay: 0.6, options: .CurveEaseOut, animations: animateInBottom, completion: animateInImage)
    }
    
    func animateInQuote() {
        // Just the movements, this is already inside of an animation
        quoteLabel.alpha = 1
        quoteLabel.center.y -= 100
        topBackgroundView.center.y = -100
    }
    
    func animateInBottom() {
        // Just the movements, this is already inside of an animation
        tweetButton.alpha = 1
        bottomBackgroundView.center.y = view.bounds.height + 100
    }
    
    func animateInImage(_: Bool) {
        // Just the movements, this is already inside of an animation
        mainImageView.alpha = 1
        mainImageView.borderWidth = 5
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
