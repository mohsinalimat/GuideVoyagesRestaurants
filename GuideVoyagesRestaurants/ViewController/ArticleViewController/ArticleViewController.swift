//
//  ArticleViewController.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 28/08/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController, UIScrollViewDelegate, UIWebViewDelegate {

    @IBOutlet weak var articleWebView: UIWebView!
    
    @IBOutlet var headerImageView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        /* ----------------------
        Navigation buttons
        ---------------------- */
        
        // Set up navigation items
        self.navigationItem.title = "Restaurant"
        var btnName = UIButton()
        btnName.setImage(UIImage(named: "partager"), forState: .Normal)
        //btnName.addTarget(self, action: #selector(self.showMapView), forControlEvents: .TouchDown)
        btnName.frame = CGRectMake(0, 0, 22, 22)
        
        let shareButton = UIBarButtonItem()
        shareButton.customView = btnName
        
        btnName = UIButton()
        btnName.setImage(UIImage(named: "localisation"), forState: .Normal)
        //btnName.addTarget(self, action: #selector(self.showMapView), forControlEvents: .TouchDown)
        btnName.frame = CGRectMake(0, 0, 22, 22)
        
        let locButton = UIBarButtonItem()
        locButton.customView = btnName
        
        
        self.navigationItem.rightBarButtonItems = [shareButton, locButton]
        
        /* ----------------------
         Adding the loading animation
         ---------------------- */
        
        /*let loadingView = LoadingView.instanceFromNib()
        loadingView.tag = 1
        self.view.insertSubview(loadingView, aboveSubview: self.articleWebView)*/
        
        
        /* ----------------------
         Loading the article html with webview
         ---------------------- */
        
        //let url = NSURL(string: "http://localhost/guide_voyage/article.html")
        let url = NSURL(string: "https://di2pra.com/voyages/article.html")
        self.articleWebView.loadRequest(NSURLRequest(URL: url!))
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
    
    // MARK: - WebView
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.URL?.scheme == "inapp" {
            
            if request.URL?.host == "capture" {
                let authorViewController = NewAuthorViewController(nibName: "NewAuthorViewController", bundle: nil)
                self.navigationController?.pushViewController(authorViewController, animated: true)
            }
            
            return false
        }
        
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if let loadingView = self.view.viewWithTag(1) {
            loadingView.removeFromSuperview()
        }
    }
    
    // MARK: - ScrollView
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        
        if offset > 100 {
           
            self.navigationItem.title = "Velouté d'asperge et oeuf coulant"
            
        } else {
           self.navigationItem.title = "Restaurant" 
        }
        
        
        
        /*let offset = scrollView.contentOffset.y
        var headerTransform = CATransform3DIdentity
        
        if offset < 0 {
            
            let headerScaleFactor:CGFloat = -(offset) / headerView.bounds.height
            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor)) - headerView.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            headerView.layer.transform = headerTransform
        }*/
        
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
