//
//  NewAuthorViewController.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 02/09/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit

class NewAuthorViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "A propos de Frédéric Lacroix"
        
        let url = NSURL(string: "http://localhost/guide_voyage/auteur.html")
        self.webView.loadRequest(NSURLRequest(URL: url!))
        self.webView.scrollView.showsVerticalScrollIndicator = false
        self.webView.scrollView.showsHorizontalScrollIndicator = false
        self.webView.scrollView.bounces = false
        self.webView.opaque = false
        self.webView.backgroundColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
