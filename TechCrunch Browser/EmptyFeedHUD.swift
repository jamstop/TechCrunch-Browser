//
//  EmptyFeedHUD.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 2/3/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import UIKit

class EmptyFeedHUD: UIView {
    
    var view: UIView!
    
    class var sharedHUD : EmptyFeedHUD {
        struct Static {
            static var instance : EmptyFeedHUD?
            static var token : dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = EmptyFeedHUD()
        }
        return Static.instance!
    }
    
    init() {
        //Initialising Code
        super.init(frame: CGRectZero)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "EmptyFeedHUD", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    
    // MARK: -Public Methods
    
    // Show the HUD added to the mentioned view
    func showInView(view : UIView) {
        self.hide()
        self.frame = view.frame
        view.addSubview(self)
    }
    
    // Show the HUD added to the mentioned window
    func showInWindow(window : UIWindow) {
        self.showInView(window)
    }
    
    // Removes the HUD from its superview
    func hide() {
        if self.superview != nil
        {
            self.removeFromSuperview()
        }
    }
    
    
}


