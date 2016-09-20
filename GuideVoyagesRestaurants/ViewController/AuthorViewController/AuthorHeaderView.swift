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
        
        self.backgroundColor = UIColor.clear
        
        //self.profileImageView.layer.cornerRadius = 75.0
        self.profileImageView.layer.borderColor = bgColor.cgColor
        self.profileImageView.layer.borderWidth = 5.0
        
        self.profileImageView.image = UIImage(named: "fredericlacroix.jpg")
        
    }
}
