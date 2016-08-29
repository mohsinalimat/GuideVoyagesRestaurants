//
//  NewArticleViewController.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 29/08/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit

class NewArticleViewController: UIViewController, UIScrollViewDelegate, UIWebViewDelegate {
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var scrollViewContainer: UIView!
    @IBOutlet weak var articleTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //print(coverView.bounds)
        
        // Header - Image
        /*headerImageView = UIImageView(frame: coverView.bounds)
        headerImageView?.image = UIImage(named: "5.jpg")
        headerImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        coverView.insertSubview(headerImageView, atIndex: 0)*/
        
        //coverView.clipsToBounds = true
        
        
        scrollView.delegate = self
        
        articleTitle.text = "Velouté d'asperge et oeuf coulant".uppercaseString
        
        
        let url = NSURL(string: "http://localhost/guide_voyage/article.html")
        //let url = NSURL(string: "https://di2pra.com/voyages/article.html")
        self.webView.loadRequest(NSURLRequest(URL: url!))
        
        webView.scrollView.scrollEnabled = false
        webView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        /*if let widthString = webView.stringByEvaluatingJavaScriptFromString("document.width"),
            width = Float(widthString) {
            
            var rect = webView.frame
            rect.size.height = CGFloat(webView.scrollView.contentSize.height)
            rect.size.width = CGFloat(width)
            webView.frame = rect
            
            print(webView.bounds.size.height)
            
            let constraint = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: webView.bounds.size.height)
            
            scrollViewContainer.addConstraint(constraint)
            
        }*/
        
        /*var frame = webView.frame
        frame.size.height = webView.scrollView.contentSize.height
        webView.frame = frame
        
        print(webView.frame.size.height)*/
        
        
        //let constraint = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: webView.frame.size.height)
        
        //scrollViewContainer.addConstraint(constraint)
        
        

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        var headerTransform = CATransform3DIdentity
        
        if offset < 0 {
            
            let headerScaleFactor:CGFloat = -(offset) / coverView.bounds.height
            let headerSizevariation = ((coverView.bounds.height * (1.0 + headerScaleFactor)) - coverView.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            coverView.layer.transform = headerTransform
        }
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
