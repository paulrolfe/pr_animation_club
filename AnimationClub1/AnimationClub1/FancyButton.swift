//
//  FancyButton.swift
//  AnimationClub1
//
//  Created by Paul Rolfe on 11/15/15.
//  Copyright © 2015 Paul Rolfe. All rights reserved.
//

//  Views adding this will create create and add constraints. Then create subbuttons and add them.
//

import UIKit
import Cartography

class FancyButton: UIView {
    
    private var subButtonArray: [FancySubButton] = []
    private var titleButton = UIButton(type: .System)
    private var underButtonView = UIView()
    private var buttonConstraintGroup = ConstraintGroup()
    
    var titleTextColor: UIColor? {
        set {
            self.titleButton.setTitleColor(newValue, forState: .Normal)
        }
        get {
            return self.titleButton.titleLabel?.textColor
        }
    }
    
    var titleBackground: UIColor? {
        set {
            self.titleButton.backgroundColor = newValue
        }
        get {
            return self.titleButton.backgroundColor
        }
    }
    
    var title: String? {
        set {
            self.titleButton.setTitle(newValue, forState: .Normal)
        }
        get {
            return self.titleButton.titleLabel?.text
        }
    }
    
    init(title: String) {
        super.init(frame: CGRectZero)
        self.titleButton.setTitle(title, forState: .Normal)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        clipsToBounds = true
        self.backgroundColor = UIColor.fancy_brown()
        
        title = "BUTTON"
        titleButton.titleLabel?.font = UIFont.boldSystemFontOfSize(21)
        titleButton.addTarget(self, action: "titleButtonWasPressed", forControlEvents: .TouchUpInside)
        titleBackground = UIColor.fancy_gold()
        titleTextColor = UIColor.fancy_brown()
                
        addSubview(titleButton)
        addSubview(underButtonView)
        
        //add constraints
        constrain(titleButton, self) { (titleButton, view) -> () in
            titleButton.bottom == view.bottom
            titleButton.top == view.top
            titleButton.leading == view.leading
            titleButton.trailing == view.trailing
        }
        
        constrain(underButtonView, self) { (subButtons, view) -> () in
            subButtons.height == view.height
            subButtons.width == view.width
            subButtons.center == view.center
        }
    }
    
    func addSubButton(newButton: FancySubButton) {
        newButton.tintColor = UIColor.whiteColor()
        newButton.addTarget(self, action: "subButtonWasPressed:", forControlEvents: .TouchUpInside)
        subButtonArray.append(newButton)
        underButtonView.addSubview(newButton)
        //add constraints for subbuttons
        
        constrain(subButtonArray, replace: buttonConstraintGroup) { (layoutProxyArray) -> () in
            
            for i in 0...(layoutProxyArray.count - 1) {
                let view = layoutProxyArray[i]
                view.top == view.superview!.top
                view.bottom == view.superview!.bottom
                
                if i == 0 {
                    view.leading == view.superview!.leading
                } else {
                    view.leading == layoutProxyArray[i-1].trailing
                    view.width == layoutProxyArray[i-1].width
                }
                
                if i == layoutProxyArray.count - 1 {
                    view.trailing == view.superview!.trailing
                }
            }
        }
    }
    
    func titleButtonWasPressed() {
        //slide over.
        underButtonView.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(bounds), 0)
        
        UIView.animateWithDuration(0.5) { () -> Void in
            self.titleButton.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(self.bounds), 0)
            self.underButtonView.transform = CGAffineTransformIdentity
        }
    }
    
    func subButtonWasPressed(button: FancySubButton) {
        // Expand out some layer. And slide the button backw
        let circle = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        circle.layer.cornerRadius = CGRectGetHeight(circle.bounds) / 2
        circle.backgroundColor = UIColor.fancy_purple().colorWithAlphaComponent(0.5)
        underButtonView.addSubview(circle)
        constrain(circle, button) { (circle, button) in
            circle.width == circle.height
            circle.width == 20
            circle.center == button.center
        }  
        
        let scale = (CGRectGetWidth(underButtonView.bounds) / 20) * 2
        UIView.animateWithDuration(0.5, animations: {
            
            circle.transform = CGAffineTransformMakeScale(scale, scale)
            
            }) { _ in
            UIView.animateWithDuration(0.5, animations: {
                
                self.titleButton.transform = CGAffineTransformIdentity

                }) { _ in
                circle.removeFromSuperview()
                    
            }
        }

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = CGRectGetHeight(bounds) / 2
        titleButton.layer.cornerRadius = CGRectGetHeight(bounds) / 2
        self.insertSubview(titleButton, aboveSubview: underButtonView)
    }
}

class FancySubButton: UIButton {
    
    var buttonBlock: () -> () = {}
    
    init() {
        super.init(frame: CGRectZero)
        self.setup()
    }
    
    convenience init(image: UIImage, block: Void -> Void) {
        self.init()
        self.setImage(image, forState: .Normal)
        self.buttonBlock = block
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        imageView?.contentMode = .ScaleAspectFit
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        addTarget(self, action: "buttonPressed", forControlEvents: .TouchUpInside)
    }
    
    func buttonPressed() {
        buttonBlock()
    }
}

extension UIColor {
    class func fancy_gold() -> UIColor {
        return UIColor(red:0.87, green:0.8, blue:0.46, alpha:1)
    }
    
    class func fancy_brown() -> UIColor {
        return UIColor(red:0.35, green:0.19, blue:0.16, alpha:1)
    }
    
    class func fancy_purple() -> UIColor {
        return UIColor(red:0.76, green:0.69, blue:0.74, alpha:1)
    }
}
