//
//  TopFadingScrollView.swift
//  AnimationClub_Tableview
//
//  Created by Paul Rolfe on 5/31/16.
//  Copyright © 2016 Paul Rolfe. All rights reserved.
//

import UIKit

class TopFadingScrollView: UIScrollView, UIScrollViewDelegate {
    
    var views: [UIView] = [] {
        didSet {
            reload()
        }
    }
    
    private var totalContentHeight: CGFloat {
        let viewHeight = views.reduce(0) { previousValue, currentView in
            return previousValue + currentView.bounds.height
        }
        return viewHeight
    }
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Public
    
    func reload(animated animated: Bool = false) {
        updateScrollableContentSize()
        if animated {
            UIView.animateWithDuration(0.3) {
                self.placeViewsInContentView()
            }
        } else {
            placeViewsInContentView()
        }
    }
    
    // MARK: Private
    
    private func setup() {
        showsVerticalScrollIndicator = false
        delegate = self
    }
    
    private func updateScrollableContentSize() {
        contentSize = CGSize(width: bounds.width, height: totalContentHeight)
    }
    
    // For now, allowing views to be different widths?
    private func placeViewsInContentView() {
        var currentOrigin = CGPoint.zero
        views.forEach { view in
            
            view.frame = CGRect(origin: currentOrigin, size: view.bounds.size)
            
            if view.superview != self {
                addSubview(view)
            }
            currentOrigin.y += view.bounds.height
        }
    }
    
    private func viewAt(y y: CGFloat) -> UIView? {
        var whichView: UIView?
        var yValue = y
        for view in views {
            yValue -= view.bounds.height
            if yValue < 0 {
                whichView = view
                break
            }
        }
        
        return whichView
    }
    
    private func originalYForView(view: UIView?) -> CGFloat {
        var yValue: CGFloat = 0
        for aView in views {
            if view == aView {
                break
            }
            yValue += aView.bounds.height
        }
        return yValue
    }
    
    private func desiredZoomForView(view: UIView?, atY y: CGFloat) -> CGFloat {
        guard let height = view?.bounds.height else { return 1.0 }
        
        let startY = originalYForView(view)
        
        let relativeY = y - startY
        let zoom = 1 - (relativeY / height)
        return zoom.constrainedBetween(low: 0.0001, high: 1)
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let topY = scrollView.contentOffset.y
        guard topY > 0 else {
            views.forEach {
                    $0.transform = CGAffineTransformIdentity
                    $0.frame.origin = CGPoint(x: 0, y: originalYForView($0))
                    $0.alpha = 1
            }
            return
        }
        let topView = viewAt(y: topY)
        topView?.frame.origin.y = topY
        
        let zoom = desiredZoomForView(topView, atY: topY)
        topView?.transform = CGAffineTransformMakeScale(zoom, zoom)
        
        topView?.alpha = zoom
        
        views.filter { $0 != topView }
            .forEach {
                $0.transform = CGAffineTransformIdentity
                $0.frame.origin = CGPoint(x: 0, y: originalYForView($0))
                $0.alpha = 1
            }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateScrollableContentSize()
    }
}

extension Comparable {
    public func constrainedBetween(low low: Self, high: Self) -> Self {
        var val = Swift.min(self, high)
        val = Swift.max(val, low)
        return val
    }
}
