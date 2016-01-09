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
            layer.borderColor = borderColor.CGColor
            layoutIfNeeded()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        didSet {
            // TODO: This is happening poorly still.
            let circlePath = UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2))
            roundedLayer.path = circlePath.CGPath
            roundedLayer.fillColor = UIColor.clearColor().CGColor
            roundedLayer.strokeColor = UIColor.whiteColor().CGColor
            roundedLayer.lineWidth = borderWidth * 2 // because the path is in the middle of the stroke.
            setNeedsLayout()
        }
    }
    
    var radius: CGFloat {
        return min(CGRectGetHeight(bounds), CGRectGetWidth(bounds)) / 2
    }
    
    private var roundedLayer = CAShapeLayer()
    
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
        layer.addSublayer(roundedLayer)
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = radius
    }
}