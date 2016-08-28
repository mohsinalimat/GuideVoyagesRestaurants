//
//  ArticleViewController.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 28/08/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit

let offset_HeaderStop:CGFloat = 50.0

class ArticleViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var articleWebView: UIWebView!
    
    @IBOutlet var headerImageView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up navigation items
        self.navigationItem.title = "Titre de l'article"
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "share.png"), forState: .Normal)
        //btnName.addTarget(self, action: #selector(self.showMapView), forControlEvents: .TouchDown)
        btnName.frame = CGRectMake(0, 0, 22, 22)
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        // Load Cover Image
        headerImageView = UIImageView(frame: headerView.bounds)
        headerImageView?.image = UIImage(named: "1.jpg")
        headerImageView?.contentMode = UIViewContentMode.ScaleAspectFit
        headerView.insertSubview(headerImageView, atIndex: 1)
        headerView.clipsToBounds = true
        
        

        // Do any additional setup after loading the view.
        
        
        // Load article html
        guard let path = NSBundle.mainBundle().pathForResource("article", ofType: "html") else {
            return
        }
        let url = NSURL(fileURLWithPath: path)
        self.articleWebView.loadRequest(NSURLRequest(URL:url))
        self.articleWebView.scrollView.delegate = self
        self.articleWebView.scrollView.showsVerticalScrollIndicator = false
        self.articleWebView.scrollView.showsHorizontalScrollIndicator = false
        self.articleWebView.opaque = false
        self.articleWebView.backgroundColor = UIColor.clearColor()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        var headerTransform = CATransform3DIdentity
        
        if offset < 0 {
            
            let headerScaleFactor:CGFloat = -(offset) / headerView.bounds.height
            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor)) - headerView.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            headerView.layer.transform = headerTransform
        }
        
        /*else {
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            headerView.layer.transform = headerTransform
        }*/
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
