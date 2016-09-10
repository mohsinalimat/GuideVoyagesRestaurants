//
//  CoverView.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 09/09/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit

class CoverView: UIView {
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var descView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        
        descView.backgroundColor = bgColor.colorWithAlphaComponent(0.8)
        
        let bounds = descView.bounds as CGRect!
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        visualEffectView.userInteractionEnabled = false
        descView.addSubview(visualEffectView)
        
        descView.sendSubviewToBack(visualEffectView)
        
    }
    

}
