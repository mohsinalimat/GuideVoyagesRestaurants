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
    
    @IBOutlet weak var articleHeaderView: ArticleHeaderView!
    @IBOutlet var webView: UIWebView!
    
    var article:Article?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        /* ----------------------
         NAVIGATION BAR
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
        if let cover = article?.cover {
            articleHeaderView.coverImage.sd_setImage(with: URL(string: cover))
        }
        
        articleHeaderView.titre.text = article?.title.uppercased()
        articleHeaderView.categorie.text = article?.category.uppercased()
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
        
        
        webView = UIWebView(frame: CGRect.zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        
        //let url = NSURL(string: "http://localhost/guide_voyage/article.html")
        
        if let id = article?.id {
            let url = URL(string: "http://www.guide-restaurants-et-voyages-du-monde.com/articleforiphone/\(id)")            
            webView.loadRequest(URLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60))
        }
        
        
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
                if let authorViewController = storyboard?.instantiateViewController(withIdentifier: "authorViewController") as? AuthorViewController {
                    self.navigationController?.pushViewController(authorViewController, animated: true)
                }
            }
            
            return false
        }
        
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        if let loadingView = self.view.viewWithTag(1) as? LoadingView {
            loadingView.animating = false
            loadingView.removeFromSuperview()
            webView.scrollView.isScrollEnabled = true
        }
        
    }
    
    /*func webViewDidFinishLoad(_ webView: UIWebView) {
        
        if let loadingView = self.view.viewWithTag(1) {
            loadingView.removeFromSuperview()
            webView.scrollView.isScrollEnabled = true
        }
    }*/
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y + 3/4 * UIScreen.main.bounds.width
        var coverImageTransform = CATransform3DIdentity
        var coverDescTransform = CATransform3DIdentity
        
        if offset < 0 {
            
            let coverImageScaleFactor:CGFloat = -(offset) / articleHeaderView.coverImage.bounds.height
            let coverImageSizevariation = ((articleHeaderView.coverImage.bounds.height * (1.0 + coverImageScaleFactor)) - articleHeaderView.coverImage.bounds.height)/2.0
            coverImageTransform = CATransform3DTranslate(coverImageTransform, 0, coverImageSizevariation, 0)
            coverImageTransform = CATransform3DScale(coverImageTransform, 1.0 + coverImageScaleFactor, 1.0 + coverImageScaleFactor, 0)
            
            coverDescTransform = CATransform3DTranslate(coverDescTransform, 0, -offset, 0)
            
            
        } else {
            coverDescTransform = CATransform3DTranslate(coverDescTransform, 0, max(-(3/4 * self.view.bounds.width), -offset), 0)
            
            
            if offset > (3/4 * self.view.bounds.width - articleHeaderView.descView.frame.height) {
                self.navigationItem.title = article?.title
            } else {
                self.navigationItem.title = article?.category.uppercased()
            }
            
        }
        
        articleHeaderView.coverImage.layer.transform = coverImageTransform
        articleHeaderView.descView.layer.transform = coverDescTransform
        
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
