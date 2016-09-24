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
    
    @IBOutlet weak var categorie: UILabel!
    @IBOutlet weak var titre: UILabel!
    @IBOutlet weak var auteur: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        
        descView.backgroundColor = bgColor.withAlphaComponent(0.8)
        
        let bounds = descView.bounds as CGRect!
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = bounds!
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.isUserInteractionEnabled = false
        descView.addSubview(visualEffectView)
        
        descView.sendSubview(toBack: visualEffectView)
        
    }
    

}
