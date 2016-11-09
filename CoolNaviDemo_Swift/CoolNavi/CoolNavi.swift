//
//  CoolNavi.swift
//  CoolNaviDemo_Swift
//
//  Created by ian on 15/11/26.
//  Copyright © 2015年 ian. All rights reserved.
//

import UIKit
import Kingfisher
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


typealias imgActionCallBackFun = ()->Void

class CoolNavi: UIView {
    
    var scrollView: UIScrollView?
    var myClosure:imgActionCallBackFun?
    func initWithClosure(_ closure:imgActionCallBackFun?){
        myClosure = closure
    }

    var backImageView: UIImageView?
    var headerImageView: UIImageView?
    var titleLabel: UILabel?
    var subTitleLabel: UILabel?
    var prePoint: CGPoint?
    var tap: UITapGestureRecognizer?
    

    
    func myInit(_ frame: CGRect, backImageName: String, headerImageURL: String, title: String, subTitle: String){
        
        self.frame = frame
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
        
        backImageView = UIImageView(frame: CGRect(x: 0, y: -0.5*frame.size.height, width: frame.size.width, height: frame.size.height*1.5))
        backImageView?.image = UIImage.init(named: backImageName)
        backImageView?.contentMode = UIViewContentMode.scaleAspectFill
    
        headerImageView = UIImageView(frame:CGRect(x: frame.size.width * 0.5 - 70*0.5, y: 0.27*frame.size.height, width: 70, height: 70))
        headerImageView?.kf.setImage(with: URL(string: headerImageURL)!)
        headerImageView?.layer.masksToBounds = true
        headerImageView?.layer.cornerRadius = (headerImageView?.frame.size.width)!/2.0
        headerImageView?.isUserInteractionEnabled = true
        tap = UITapGestureRecognizer(target: self, action: #selector(CoolNavi.tapAction(_:)))
        headerImageView?.addGestureRecognizer(tap!)
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0.6 * frame.size.height, width: frame.size.width, height: frame.size.height * 0.2))
        titleLabel?.textAlignment = NSTextAlignment.center
        titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        titleLabel?.text = title
        titleLabel?.textColor = UIColor.white
        
        subTitleLabel = UILabel(frame: CGRect(x: 0, y: 0.75 * frame.size.height, width: frame.size.width, height: frame.size.height * 0.1))
        subTitleLabel?.textAlignment = NSTextAlignment.center
        subTitleLabel?.font = UIFont.systemFont(ofSize: 12)
        subTitleLabel?.text = subTitle
        subTitleLabel?.textColor = UIColor.white
        
        self.addSubview(backImageView!)
        self.addSubview(headerImageView!)
        self.addSubview(titleLabel!)
        self.addSubview(subTitleLabel!)

    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.scrollView?.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
        self.scrollView?.contentInset = UIEdgeInsetsMake(self.frame.size.height, 0, 0, 0)
        self.scrollView?.scrollIndicatorInsets = (self.scrollView?.contentInset)!;
    }
    
    var newOffset: CGPoint?
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        newOffset = (change![NSKeyValueChangeKey.newKey] as AnyObject).cgPointValue
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
    
    func updateSubViewsWithScrollOffset(_ theNewOffset: CGPoint){
        destinaOffset = -64
        startChangeOffset = -(self.scrollView?.contentInset.top)!
        if(theNewOffset.y<startChangeOffset){
            myNewOffset = CGPoint(x: theNewOffset.x, y: startChangeOffset!)
        } else if (theNewOffset.y>destinaOffset){
            myNewOffset = CGPoint(x: theNewOffset.x, y: destinaOffset!)
        } else {
            myNewOffset = CGPoint(x: theNewOffset.x, y: theNewOffset.y)
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

        t = CGAffineTransform(translationX: 0,y: (subviewOffset!-0.35*self.frame.size.height)*(1-myAlpha!))
        headerImageView!.transform = t!.scaledBy(x: imageReduce!,y: imageReduce!)
        self.titleLabel?.frame = CGRect(x: 0, y: 0.6*self.frame.size.height+(subviewOffset!-0.45*self.frame.size.height)*(1-myAlpha!), width: self.frame.size.width, height: self.frame.size.height*0.2)
        self.subTitleLabel!.frame = CGRect(x: 0, y: 0.75*self.frame.size.height+(subviewOffset!-0.45*self.frame.size.height)*(1-myAlpha!), width: self.frame.size.width, height: self.frame.size.height*0.1);
    }
    
    func tapAction(_ sender: AnyObject){
        if (myClosure != nil){
            myClosure!()
        }
    }
    
}
