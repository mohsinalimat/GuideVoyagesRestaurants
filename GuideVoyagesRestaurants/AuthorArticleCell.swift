//
//  AuthorArticleCell.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 17/09/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit

class AuthorArticleCell: UITableViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var categorieLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
