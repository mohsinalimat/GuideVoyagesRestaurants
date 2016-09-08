//
//  LoadingView.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 02/09/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    @IBOutlet weak var iconHeader: UIImageView!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "LoadingView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    override func awakeFromNib() {
        
        self.backgroundColor = bgColor
        self.animate()
        
        /*let body = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 55.0, height: 25.0)))
        body.image = UIImage(named: "geisha_body")*/
        
    }
    
    func animate() {
        if !self.hidden {
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                self.iconHeader.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
                
                }, completion: { (finished) -> Void in
                    
                    UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                        
                        self.iconHeader.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_4))
                        
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
