//
//  NewArticleViewController.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 29/08/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleViewController: UIViewController, UIScrollViewDelegate, UIWebViewDelegate {
    
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
        btnName.setImage(UIImage(named: "partager"), for: UIControlState())
        //btnName.addTarget(self, action: #selector(self.showMapView), forControlEvents: .TouchDown)
        btnName.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        let shareButton = UIBarButtonItem()
        shareButton.customView = btnName
        
        
        btnName = UIButton()
        btnName.setImage(UIImage(named: "localisation"), for: UIControlState())
        //btnName.addTarget(self, action: #selector(self.showMapView), forControlEvents: .TouchDown)
        btnName.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        let locButton = UIBarButtonItem()
        locButton.customView = btnName
        
        
        btnName = UIButton()
        btnName.setImage(UIImage(named: "back"), for: UIControlState())
        btnName.addTarget(self, action: #selector(self.popToRoot), for: .touchDown)
        btnName.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        let backBarButton = UIBarButtonItem()
        backBarButton.customView = btnName
        
        
        self.navigationItem.rightBarButtonItems = [shareButton, locButton]
        self.navigationItem.leftBarButtonItem = backBarButton
        
        /* ----------------------
         ---------------------- */
        
        /* ----------------------
         COVER VIEW INIT
         ---------------------- */
        coverView.coverImage.sd_setImage(with: URL(string: "https://di2pra.com/voyages/img/1.jpg"))
        /* ----------------------
         ---------------------- */
        
        
        /* ----------------------
         LOADING VIEW INIT
         ---------------------- */
        let loadingView = LoadingView(frame: CGRect(origin: CGPoint(x: 0, y: 3/4 * UIScreen.main.bounds.width), size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (3/4 * UIScreen.main.bounds.width))))
        loadingView.tag = 1
        
        self.view.addSubview(loadingView)
        /* ----------------------
         ---------------------- */
        
        
        /* ----------------------
         WEBVIEW INIT
         ---------------------- */
        
        print(self.navigationController?.navigationBar.frame.size.height)
        
        webView = UIWebView(frame: CGRect.zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        
        //let url = NSURL(string: "http://localhost/guide_voyage/article.html")
        let url = URL(string: "https://di2pra.com/voyages/article.php")
        
        webView.loadRequest(URLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60))
        webView.delegate = self
        webView.scrollView.delegate = self
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.contentInset.top = 3/4 * UIScreen.main.bounds.width
        webView.scrollView.scrollIndicatorInsets.top = 3/4 * UIScreen.main.bounds.width
        
        self.view.addSubview(webView)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.webView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.bottomLayoutGuide, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: self.webView, attribute: .bottom, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.webView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.webView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0))
        
        /* ----------------------
         ---------------------- */
        
        

    
    }
    
    func popToRoot(_ sender:UIBarButtonItem){
        self.navigationController!.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - WebView
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.url?.scheme == "inapp" {
            
            if request.url?.host == "capture" {
                let authorViewController = AuthorViewController(nibName: "AuthorViewController", bundle: nil)
                self.navigationController?.pushViewController(authorViewController, animated: true)
            }
            
            return false
        }
        
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        if let loadingView = self.view.viewWithTag(1) {
            loadingView.removeFromSuperview()
            webView.scrollView.isScrollEnabled = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y + 3/4 * UIScreen.main.bounds.width
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
