//
//  ArticleHeader.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 01/10/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit

class ArticleHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = bgColor
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
