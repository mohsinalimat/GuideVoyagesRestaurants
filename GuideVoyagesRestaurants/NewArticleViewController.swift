//
//  NewArticleViewController.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 29/08/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit
import SDWebImage

class NewArticleViewController: UIViewController, UIScrollViewDelegate, UIWebViewDelegate {
    
    @IBOutlet weak var coverView: CoverView!
    @IBOutlet var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        /* ----------------------
         Navigation bar
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
        
        
        btnName = UIButton()
        btnName.setImage(UIImage(named: "back"), forState: .Normal)
        btnName.addTarget(self, action: #selector(self.popToRoot), forControlEvents: .TouchDown)
        btnName.frame = CGRectMake(0, 0, 22, 22)
        let backBarButton = UIBarButtonItem()
        backBarButton.customView = btnName
        
        
        self.navigationItem.rightBarButtonItems = [shareButton, locButton]
        self.navigationItem.leftBarButtonItem = backBarButton
        
        /* ----------------------
         ---------------------- */
        
        /* ----------------------
         COVER VIEW INIT
         ---------------------- */
        coverView.coverImage.sd_setImageWithURL(NSURL(string: "https://di2pra.com/voyages/img/1.jpg"))
        /* ----------------------
         ---------------------- */
        
        
        /* ----------------------
         LOADING VIEW INIT
         ---------------------- */
        let loadingView = LoadingView(frame: CGRect(origin: CGPoint(x: 0, y: 3/4 * UIScreen.mainScreen().bounds.width), size: CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - (3/4 * UIScreen.mainScreen().bounds.width))))
        loadingView.tag = 1
        
        self.view.addSubview(loadingView)
        /* ----------------------
         ---------------------- */
        
        
        /* ----------------------
         WEBVIEW INIT
         ---------------------- */
        
        webView = UIWebView(frame: UIScreen.mainScreen().bounds)
        webView.opaque = false
        webView.backgroundColor = UIColor.clearColor()
        
        //let url = NSURL(string: "http://localhost/guide_voyage/article.html")
        let url = NSURL(string: "https://di2pra.com/voyages/article.php")
        webView.loadRequest(NSURLRequest(URL: url!))
        webView.delegate = self
        webView.scrollView.delegate = self
        webView.scrollView.scrollEnabled = false
        webView.scrollView.contentInset.top = 3/4 * UIScreen.mainScreen().bounds.width
        webView.scrollView.scrollIndicatorInsets.top = 3/4 * UIScreen.mainScreen().bounds.width
        
        self.view.addSubview(webView)
        
        /* ----------------------
         ---------------------- */
        
        

    
    }
    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController!.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - WebView
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.URL?.scheme == "inapp" {
            
            if request.URL?.host == "capture" {
                let authorViewController = AuthorViewController(nibName: "AuthorViewController", bundle: nil)
                self.navigationController?.pushViewController(authorViewController, animated: true)
            }
            
            return false
        }
        
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        if let loadingView = self.view.viewWithTag(1) {
            loadingView.removeFromSuperview()
            webView.scrollView.scrollEnabled = true
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y + 3/4 * UIScreen.mainScreen().bounds.width
        var coverImageTransform = CATransform3DIdentity
        var coverDescTransform = CATransform3DIdentity
        
        if offset < 0 {
            
            let coverImageScaleFactor:CGFloat = -(offset) / coverView.coverImage.bounds.height
            let coverImageSizevariation = ((coverView.coverImage.bounds.height * (1.0 + coverImageScaleFactor)) - coverView.coverImage.bounds.height)/2.0
            coverImageTransform = CATransform3DTranslate(coverImageTransform, 0, coverImageSizevariation, 0)
            coverImageTransform = CATransform3DScale(coverImageTransform, 1.0 + coverImageScaleFactor, 1.0 + coverImageScaleFactor, 0)
            
            coverDescTransform = CATransform3DTranslate(coverDescTransform, 0, -offset, 0)
            
            
        } else {
            coverDescTransform = CATransform3DTranslate(coverDescTransform, 0, max(-(3/4 * self.view.bounds.width), -offset), 0)
            
            
            if offset > (3/4 * self.view.bounds.width - coverView.descView.frame.height) {
                self.navigationItem.title = "Velouté d'Asperges et d'oeuf coulant"
            } else {
                self.navigationItem.title = "Restaurant"
            }
            
        }
        
        coverView.coverImage.layer.transform = coverImageTransform
        coverView.descView.layer.transform = coverDescTransform
        
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
