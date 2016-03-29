//
//  CAGradientLayer.swift
//  SwiftWisdom
//
//  Created by Paul Rolfe on 2/17/16.
//  Copyright © 2016 Intrepid. All rights reserved.
//

import UIKit

public final class BasicVerticalGradientLayer : CAGradientLayer {
    public init(topColor: UIColor = .grayColor(), bottomColor: UIColor = .blackColor()) {
        super.init()
        colors = [topColor.CGColor, bottomColor.CGColor]
    }
    
    // I know this seems unnecessary, but swift gets mad about changing the frame without this.
    override public init(layer: AnyObject) {
        super.init(layer: layer)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
