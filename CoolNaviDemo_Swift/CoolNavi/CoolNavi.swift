//
//  CoolNavi.swift
//  CoolNaviDemo_Swift
//
//  Created by ian on 15/11/26.
//  Copyright © 2015年 ian. All rights reserved.
//

import UIKit
import Kingfisher

typealias imgActionCallBackFun = ()->Void

class CoolNavi: UIView {
    
    var scrollView: UIScrollView?
    var myClosure:imgActionCallBackFun?
    func initWithClosure(closure:imgActionCallBackFun?){
        myClosure = closure
    }

    var backImageView: UIImageView?
    var headerImageView: UIImageView?
    var titleLabel: UILabel?
    var subTitleLabel: UILabel?
    var prePoint: CGPoint?
    var tap: UITapGestureRecognizer?
    

    
    func myInit(frame: CGRect, backImageName: String, headerImageURL: String, title: String, subTitle: String){
        
        self.frame = frame
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = true
        
        backImageView = UIImageView(frame: CGRectMake(0, -0.5*frame.size.height, frame.size.width, frame.size.height*1.5))
        backImageView?.image = UIImage.init(named: backImageName)
        backImageView?.contentMode = UIViewContentMode.ScaleAspectFill
    
        headerImageView = UIImageView(frame:CGRectMake(frame.size.width * 0.5 - 70*0.5, 0.27*frame.size.height, 70, 70))
        headerImageView?.kf_setImageWithURL(NSURL(string: headerImageURL)!)
        headerImageView?.layer.masksToBounds = true
        headerImageView?.layer.cornerRadius = (headerImageView?.frame.size.width)!/2.0
        headerImageView?.userInteractionEnabled = true
        tap = UITapGestureRecognizer(target: self, action: Selector("tapAction:"))
        headerImageView?.addGestureRecognizer(tap!)
        
        titleLabel = UILabel(frame: CGRectMake(0, 0.6 * frame.size.height, frame.size.width, frame.size.height * 0.2))
        titleLabel?.textAlignment = NSTextAlignment.Center
        titleLabel?.font = UIFont.systemFontOfSize(14.0)
        titleLabel?.text = title
        titleLabel?.textColor = UIColor.whiteColor()
        
        subTitleLabel = UILabel(frame: CGRectMake(0, 0.75 * frame.size.height, frame.size.width, frame.size.height * 0.1))
        subTitleLabel?.textAlignment = NSTextAlignment.Center
        subTitleLabel?.font = UIFont.systemFontOfSize(12)
        subTitleLabel?.text = subTitle
        subTitleLabel?.textColor = UIColor.whiteColor()
        
        self.addSubview(backImageView!)
        self.addSubview(headerImageView!)
        self.addSubview(titleLabel!)
        self.addSubview(subTitleLabel!)

    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        self.scrollView?.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
        self.scrollView?.contentInset = UIEdgeInsetsMake(self.frame.size.height, 0, 0, 0)
        self.scrollView?.scrollIndicatorInsets = (self.scrollView?.contentInset)!;
    }
    
    var newOffset: CGPoint?
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        newOffset = change!["new"]?.CGPointValue
        self.updateSubViewsWithScrollOffset(newOffset!)
    }
    
    var destinaOffset: CGFloat?
    var startChangeOffset: CGFloat?
    var subviewOffset: CGFloat?
    var newY: CGFloat?
    var d: CGFloat?
    var myAlpha: CGFloat?
    var imageReduce: CGFloat?
    var t: CGAffineTransform?
    var myNewOffset: CGPoint?
    
    func updateSubViewsWithScrollOffset(theNewOffset: CGPoint){
        destinaOffset = -64
        startChangeOffset = -(self.scrollView?.contentInset.top)!
        if(theNewOffset.y<startChangeOffset){
            myNewOffset = CGPointMake(theNewOffset.x, startChangeOffset!)
        } else if (theNewOffset.y>destinaOffset){
            myNewOffset = CGPointMake(theNewOffset.x, destinaOffset!)
        } else {
            myNewOffset = CGPointMake(theNewOffset.x, theNewOffset.y)
        }
        subviewOffset = self.frame.size.height - 40;
        newY = -myNewOffset!.y-(self.scrollView?.contentInset.top)!
        d = destinaOffset! - startChangeOffset!
        myAlpha = 1 - (myNewOffset!.y - startChangeOffset!)/d!
        imageReduce = 1 - (myNewOffset!.y - startChangeOffset!)/(d! * 2)
        
        subTitleLabel?.alpha = myAlpha!
        titleLabel?.alpha = myAlpha!
        
        self.frame.origin.y = newY!
        backImageView?.frame.origin.y = -0.5*self.frame.size.height + (1.5*self.frame.size.height - 64)*(1-myAlpha!)

        t = CGAffineTransformMakeTranslation(0,(subviewOffset!-0.35*self.frame.size.height)*(1-myAlpha!))
        headerImageView!.transform = CGAffineTransformScale(t!,imageReduce!,imageReduce!)
        self.titleLabel?.frame = CGRectMake(0, 0.6*self.frame.size.height+(subviewOffset!-0.45*self.frame.size.height)*(1-myAlpha!), self.frame.size.width, self.frame.size.height*0.2)
        self.subTitleLabel!.frame = CGRectMake(0, 0.75*self.frame.size.height+(subviewOffset!-0.45*self.frame.size.height)*(1-myAlpha!), self.frame.size.width, self.frame.size.height*0.1);
    }
    
    func tapAction(sender: AnyObject){
        if (myClosure != nil){
            myClosure!()
        }
    }
    
}
