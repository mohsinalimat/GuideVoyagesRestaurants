//
//  MapViewArticleCell.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 20/09/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit

class MapViewArticleCell: UITableViewCell {
    
    @IBOutlet weak var categorieLabel:UILabel!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var distanceLabel:UILabel!
    @IBOutlet weak var dateLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //bgView.layer.cornerRadius = 10.0
        self.backgroundColor = bgColor
        
    }

    /*$override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }*/

}
