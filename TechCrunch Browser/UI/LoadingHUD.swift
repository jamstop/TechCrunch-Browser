//
//  LoadingHUD.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/21/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import UIKit

class LoadingHUD: UIView
{
    
    private var backGroundView : UIView?
    private var progressIndicator : UIActivityIndicatorView?

    var backGroundColor : UIColor
    var loaderColor : UIColor
    
    class var sharedHUD : LoadingHUD {
        struct Static {
            static var instance : LoadingHUD?
            static var token : dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = LoadingHUD()
        }
        return Static.instance!
    }
    
    init()
    {
        //Initialising Code
        backGroundColor = UIColor(red: 255, green: 128, blue: 128, alpha: 1)
        loaderColor = UIColor.blackColor()
        super.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        backGroundColor = UIColor(red: 255, green: 128, blue: 128, alpha: 1)
        loaderColor = UIColor.blackColor()
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect)
    {
        backGroundColor = UIColor(red: 255, green: 128, blue: 128, alpha: 1)
        loaderColor = UIColor.blackColor()
        super.init(frame: frame)
    }
    
    // MARK: -Public Methods
    
    // Show the loader added to the mentioned view with the provided title and footer texts
    func showInView(view : UIView)
    {
        self.hide()
        self.frame = view.frame
        setIndicator()
        setBackGround(view)
        progressIndicator?.frame.origin = getIndicatorOrigin(backGroundView!, activityIndicatorView: progressIndicator!)
        backGroundView?.addSubview(progressIndicator!)
        view.addSubview(self)
    }
    
    // Show the loader added to the mentioned window with the provided title and footer texts
    func showInWindow(window : UIWindow)
    {
        self.showInView(window)
    }
    
    // Removes the loader from its superview
    func hide()
    {
        if self.superview != nil
        {
            self.removeFromSuperview()
            progressIndicator?.stopAnimating()
        }
    }
    
    // MARK: -Set view properties
    
    private func setBackGround(view : UIView)
    {
        if backGroundView?.superview != nil
        {
            backGroundView?.removeFromSuperview()
            let aView = backGroundView?.viewWithTag(1001) as UIView?
            aView?.removeFromSuperview()
        }
        backGroundView = UIView(frame: getBackGroundFrame(self))
        backGroundView?.backgroundColor = UIColor.clearColor()
        let translucentView = UIView(frame: backGroundView!.bounds)
        translucentView.backgroundColor = backGroundColor
        translucentView.alpha = 0.85
        translucentView.tag = 1001;
        translucentView.layer.cornerRadius = 15.0
        backGroundView?.addSubview(translucentView)
        backGroundView?.layer.cornerRadius = 15.0
        self.addSubview(backGroundView!)
    }
    
    private func setIndicator()
    {
        if progressIndicator?.superview != nil
        {
            progressIndicator?.removeFromSuperview()
        }
        progressIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        progressIndicator?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        progressIndicator?.color = loaderColor
        progressIndicator?.backgroundColor = UIColor.clearColor()
        progressIndicator?.startAnimating()
    }
    
    // MARK: -Get Frame
    
    private func getBackGroundFrame(view : UIView) -> CGRect
    {
        let side = progressIndicator!.frame.height
        let originX = view.center.x - (side/2)
        let originY = view.center.y - (side/2)
        
        //Change By Sohil
        return CGRectMake(originX, originY - 25, side, side)
    }
    
    // MARK: Get Size
    
    private func getLabelSize() -> CGSize
    {
        let width = progressIndicator!.frame.width * 3
        let height = progressIndicator!.frame.height / 1.5
        return CGSizeMake(width, height)
    }
    
    // MARK: -Get Origin
    
    private func getIndicatorOrigin(view : UIView, activityIndicatorView indicator : UIActivityIndicatorView) -> CGPoint
    {
        let side = indicator.frame.size.height
        let originX = (view.bounds.width/2) - (side/2)
        let originY = (view.bounds.height/2) - (side/2)
        return CGPointMake(originX, originY)
    }
    
    
}

