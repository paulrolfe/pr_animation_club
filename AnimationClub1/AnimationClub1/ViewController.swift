//
//  ViewController.swift
//  AnimationClub1
//
//  Created by Paul Rolfe on 11/15/15.
//  Copyright © 2015 Paul Rolfe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var bigImage: UIImageView!
    @IBOutlet weak var fancyButton: FancyButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let twitter = FancySubButton(image: UIImage.fancy_twitter()) {
            // Do the sharing here
        }
        
        let facebook = FancySubButton(image: UIImage.fancy_facebook()) {
            // Do the sharing here
        }
        
        let google = FancySubButton(image: UIImage.fancy_google()){
            // Do the sharing here
        }
        
        fancyButton.addSubButton(twitter)
        fancyButton.addSubButton(google)
        fancyButton.addSubButton(facebook)
        fancyButton.title = "SHARE"
    }
    

}

extension UIImage {
    class func fancy_twitter() -> UIImage {
        return UIImage(named: "socialMediaTwitter")!
    }
    
    class func fancy_facebook() -> UIImage {
        return UIImage(named: "socialMediaFacebook")!
    }
    
    class func fancy_google() -> UIImage {
        return UIImage(named: "socialMediaGoogle")!
    }
    
}

