//
//  AuthorDesCell.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 17/09/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit

class AuthorDescCell: UITableViewCell {
    
    @IBOutlet weak var authorDescText:UILabel!
    @IBOutlet weak var authorNameText:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        authorNameText.text = "Frédéric Lacroix".uppercased()
        
        authorDescText.text = "Nous sommes tout au sud de l'île de Kyushu dans la baie de Kagoshima pour visiter le volcan Sakurajima. C'est l'un des volcans les plus actifs du Japon, sa dernière éruption importante datant de février 2016. Lorsque le volcan est calme nous pouvons faire des balades à pied ou en véhicule tout autour du volcan."
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
