//
//  CircleBorderImageView.swift
//  AnimationClub4
//
//  Created by Paul Rolfe on 1/8/16.
//  Copyright © 2016 Paul Rolfe. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CircleBorderImageView: UIImageView {
    
    @IBInspectable var borderColor: UIColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var radius: CGFloat {
        return min(CGRectGetHeight(bounds), CGRectGetWidth(bounds)) / 2
    }
    
    override init(frame: CGRect) {
        let radius = min(frame.height, frame.width)
        borderColor = UIColor.whiteColor()
        borderWidth = 10
        super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: radius * 2, height: radius * 2))
        setup()
    }
    
    convenience init(radius: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: 2 * radius, height: 2 * radius))
    }
    
    required init?(coder aDecoder: NSCoder) {
        borderColor = UIColor.whiteColor()
        borderWidth = 10
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = radius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.CGColor
    }
}