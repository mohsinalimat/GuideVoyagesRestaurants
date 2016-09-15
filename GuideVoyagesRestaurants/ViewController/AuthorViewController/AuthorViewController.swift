//
//  AuthorViewController.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 30/08/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit

class AuthorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var header: AuthorHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    let headerInset:CGFloat = 3/4 * UIScreen.main.bounds.width + 75
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        /* ----------------------
         Navigation bar
         ---------------------- */
        
        self.navigationItem.title = "A propos de Frédéric Lacroix"
        
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "back"), for: UIControlState())
        btnName.addTarget(self, action: #selector(self.popToRoot), for: .touchDown)
        btnName.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        let backBarButton = UIBarButtonItem()
        backBarButton.customView = btnName
        
        self.navigationItem.leftBarButtonItem = backBarButton
        
        /* ----------------------
         ---------------------- */
        
        
        
        /* ----------------------
         WebView Init
         ---------------------- */
        
        /*let url = URL(string: "https://di2pra.com/voyages/article.php")
        self.webView.loadRequest(URLRequest(url: url!))
        webView.delegate = self
        webView.scrollView.delegate = self
        
        webView.scrollView.contentInset.top = 3/4 * UIScreen.main.bounds.width + header.profileImageView.frame.height / 2
        webView.scrollView.scrollIndicatorInsets.top = 3/4 * UIScreen.main.bounds.width + header.profileImageView.frame.height / 2*/
        
        /* ----------------------
         ---------------------- */
        tableView.contentInset.top = headerInset
        tableView.scrollIndicatorInsets.top = headerInset
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
    }
    
    // MARK: - ScrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y + headerInset
        
        var coverImageTransform = CATransform3DIdentity
        //var profileImageTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        if offset < 0 {
            
            let coverImageScaleFactor:CGFloat = -(offset) / header.bgImageView.bounds.height
            let coverImageSizevariation = ((header.bgImageView.bounds.height * (1.0 + coverImageScaleFactor)) - header.bgImageView.bounds.height)/2.0
            coverImageTransform = CATransform3DTranslate(coverImageTransform, 0, coverImageSizevariation, 0)
            coverImageTransform = CATransform3DScale(coverImageTransform, 1.0 + coverImageScaleFactor, 1.0 + coverImageScaleFactor, 0)
            
            //profileImageTransform = CATransform3DTranslate(profileImageTransform, 0, -offset, 0)
            
        } else {
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset, -headerInset + 150), 0)
            
            /*let profileImageScaleFactor:CGFloat = -(offset) / (-headerInset + 20)
            
            profileImageTransform = CATransform3DScale(profileImageTransform, max(0.4, 1.0 - profileImageScaleFactor), max(0.4, 1.0 - profileImageScaleFactor), 0)*/
            

            if offset == (headerInset - 20) {
                
                header.layer.zPosition = 1
                tableView.layer.zPosition = 0
                
            } else {
                header.layer.zPosition = 0
                tableView.layer.zPosition = 1
            }
            
        }
        
        header.layer.transform = headerTransform
        header.bgImageView.layer.transform = coverImageTransform
        //header.profileImageView.layer.transform = profileImageTransform
        
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "Row"
        
        cell.backgroundColor = bgColor
        
        return cell
    }
    
    
    func popToRoot(_ sender:UIBarButtonItem){
        self.navigationController!.popViewController(animated: true)
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
