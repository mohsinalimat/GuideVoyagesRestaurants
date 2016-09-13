//
//  LoadingView.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 02/09/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    var iconHeader: UIImageView! = nil
    var iconBody: UIImageView! = nil
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        iconBody = UIImageView(frame: CGRectZero)
        iconBody.image = UIImage(named: "geisha_body")
        iconBody.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(iconBody)
        
        self.addConstraint(NSLayoutConstraint(item: iconBody, attribute: NSLayoutAttribute.CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: iconBody, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: iconBody, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 55))
        self.addConstraint(NSLayoutConstraint(item: iconBody, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 25))
        
        
        iconHeader = UIImageView(frame: CGRectZero)
        iconHeader.image = UIImage(named: "geisha_head")
        iconHeader.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(iconHeader)
        
        self.addConstraint(NSLayoutConstraint(item: iconHeader, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: iconHeader, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 25))
        self.addConstraint(NSLayoutConstraint(item: iconHeader, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 25))
        self.addConstraint(NSLayoutConstraint(item: iconBody, attribute: .Top, relatedBy: .Equal, toItem: iconHeader, attribute: .Bottom, multiplier: 1, constant: 3))
        
        
        self.backgroundColor = bgColor
        self.animate()
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func animate() {
        if !self.hidden {
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                self.iconHeader!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
                
                }, completion: { (finished) -> Void in
                    
                    UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                        
                        self.iconHeader!.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_4))
                        
                        }, completion: { (finished) -> Void in
                            self.animate()
                    })
            })
        }
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
