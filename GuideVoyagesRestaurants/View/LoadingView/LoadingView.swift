//
//  LoadingView.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 02/09/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    var iconHeader: UIImageView!
    var iconBody: UIImageView!
    var animating: Bool = true
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        iconBody = UIImageView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        iconBody?.image = UIImage(named: "geisha_body")
        iconBody?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(iconBody!)
        
        iconHeader = UIImageView(frame: CGRect.zero)
        iconHeader?.image = UIImage(named: "geisha_head")
        iconHeader?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(iconHeader!)
        
        self.backgroundColor = bgColor
        
        self.setConstraints(width: 55, height: 25)
        
        self.animate()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setConstraints(width: CGFloat, height: CGFloat) {
        
        self.removeAllConstraints()
        
        self.addConstraint(NSLayoutConstraint(item: iconBody, attribute: NSLayoutAttribute.centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: iconBody, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: iconBody, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width))
        self.addConstraint(NSLayoutConstraint(item: iconBody, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height))
        
        self.addConstraint(NSLayoutConstraint(item: iconHeader, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: iconHeader, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height))
        self.addConstraint(NSLayoutConstraint(item: iconHeader, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height))
        self.addConstraint(NSLayoutConstraint(item: iconBody, attribute: .top, relatedBy: .equal, toItem: iconHeader, attribute: .bottom, multiplier: 1, constant: 3))
    }
    
    func updateSize(width: CGFloat, height: CGFloat) {
        self.setConstraints(width: width, height: height)
        self.layoutIfNeeded()
    }
    
    func animate() {
        if animating {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                self.iconHeader!.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
                
                }, completion: { (finished) -> Void in
                    
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                        
                        self.iconHeader!.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_4))
                        
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


extension UIView {
    func removeAllConstraints() {
        self.removeConstraints(self.constraints)
        for view in self.subviews {
            view.removeAllConstraints()
        }
    }
}
