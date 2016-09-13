//
//  AuthorHeaderView.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 10/09/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit

class AuthorHeaderView: UIView {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = bgColor
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.layer.borderColor = bgColor.CGColor
        self.profileImageView.layer.borderWidth = 5.0
        
    }
}
