//
//  AuthorViewController.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 30/08/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit

//let offset_HeaderStop:CGFloat = 200.0

class AuthorViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var headerImageView: UIScrollView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var header: UIView!
    
    var offset_HeaderStop:CGFloat!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "A propos de Frédéric Lacroix".uppercaseString
        self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.width / 2
        self.iconImageView.layer.borderWidth = 10.0
        self.iconImageView.layer.borderColor = bgColor.CGColor
        //self.iconImageView.clipsToBounds = true
        
        offset_HeaderStop = self.iconImageView.frame.size.height / 2
        
        
        scrollView.delegate = self
        header.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ScrollView
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        if offset < 0 {
            
            let headerScaleFactor:CGFloat = -(offset) / header.bounds.height
            let headerSizevariation = ((header.bounds.height * (1.0 + headerScaleFactor)) - header.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            header.layer.transform = headerTransform
        } else {
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
        
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / iconImageView.bounds.height / 1.4 // Slow down the animation
            let avatarSizeVariation = ((iconImageView.bounds.height * (1.0 + avatarScaleFactor)) - iconImageView.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
           /* if offset <= offset_HeaderStop {
                
                if iconImageView.layer.zPosition < header.layer.zPosition{
                    header.layer.zPosition = 0
                }
                
            }else {
                if iconImageView.layer.zPosition >= header.layer.zPosition{
                    header.layer.zPosition = 2
                }
            }*/
            
        }
        
        header.layer.transform = headerTransform
        iconImageView.layer.transform = avatarTransform
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
