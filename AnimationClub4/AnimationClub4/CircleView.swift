//
//  CircleView.swift
//  AnimationClub4
//
//  Created by Paul Rolfe on 1/8/16.
//  Copyright © 2016 Paul Rolfe. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CircleView: UIView {
    
    @IBInspectable var radius: CGFloat {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var circleColor: UIColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var roundedLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        radius = min(frame.height, frame.width)
        circleColor = UIColor.whiteColor()
        super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: radius * 2, height: radius * 2))
        setup()
    }
    
    convenience init(radius: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: 2 * radius, height: 2 * radius))
    }
    
    required init?(coder aDecoder: NSCoder) {
        radius = 0
        circleColor = UIColor.whiteColor()
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        layer.addSublayer(roundedLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let circlePath = UIBezierPath(ovalInRect: CGRect(x: CGRectGetMidX(bounds) - radius, y: 0, width: radius * 2, height: radius * 2))
        roundedLayer.path = circlePath.CGPath
        roundedLayer.fillColor = circleColor.CGColor
    }
}
