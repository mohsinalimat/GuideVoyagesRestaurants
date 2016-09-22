//
//  ContentCell.swift
//  TestProject
//
//  Created by Pradheep Rajendirane on 31/07/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {

    @IBOutlet weak var imageMain: UIImageView!
    @IBOutlet weak var descText: UILabel!
    @IBOutlet weak var imageMainHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imageMainHeight.constant = 3 * UIScreen.main.bounds.width / 4
        
        //descText.numberOfLines = 0
        
    }

}
