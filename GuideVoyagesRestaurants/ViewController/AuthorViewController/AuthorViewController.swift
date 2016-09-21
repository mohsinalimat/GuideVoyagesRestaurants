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
    
    /*let data = [
        Article(
            id: 1,
            category: Category(id: 1, title: "Voyages"),
            title: "Le volcan Sakurajima",
            author: "Frédéric Lacroix",
            cover: "1.jpg",
            desc: "Nous sommes tout au sud de l'île de Kyushu dans la baie de Kagoshima pour visiter le volcan Sakurajima. C'est l'un des volcans les plus actifs du Japon, sa dernière éruption importante datant de février 2016. Lorsque le volcan est calme nous pouvons faire des balades à pied ou en véhicule tout autour du volcan."
        ),
        Article(
            id: 2,
            category: Category(id: 1, title: "Voyages"),
            title: "Kokura et Mojiko",
            author: "Frédéric Lacroix",
            cover: "2.jpg",
            desc: "Nous voici au nord de la l'île de Kyushu pour faire une petite balade à Kokura et Mojiko. Ces deux villes ont fusionné en 1963 pour donner l'agglomération de Kitakyushu. Kokura possède un petit château dominé par un grand centre commercial ainsi qu'un marché intéressant. Mojiko est un petit port avec de nombreuses maisons occidentales."
        ),
        Article(
            id: 3,
            category: Category(id: 1, title: "Voyages"),
            title: "Takayama",
            author: "Frédéric Lacroix",
            cover: "3.jpg",
            desc: "Nous voici dans la région de Kochi au sud de l'île de Shikoku pour partir à la découverte de l'une des plus belles grottes du Japon et l'une des plus vaste. Elle est classée trésor national pour sa valeur naturelle mais elle a aussi une valeur historique pour ses trésors archéologiques découverts dans ses galeries."
        ),
        Article(
            id: 4,
            category: Category(id: 1, title: "Voyages"),
            title: "Sardegna a Tavola",
            author: "Frédéric Lacroix",
            cover: "4.jpg",
            desc: "Partons à la découverte de la petite ville de Takayama, dans les montagnes de Hida au pied des Alpes japonaises. Cette petite ville au passé historique riche porte aussi le nom de Petite Kyoto. Depuis quelques années elle est devenue l'un des sites touristiques les plus fréquentés surtout grave à son matsuri du printemps et de l'automne."
        ),
        Article(
            id: 5,
            category: Category(id: 2, title: "Restaurants"),
            title: "Sardegna a Tavola",
            author: "Frédéric Lacroix",
            cover: "5.jpg",
            desc: "Direction le marché Aligre dans le 12ème arrondissement pour partir en. Itlaie et plus précisément en Sardaigne. Nous voici chez Sardegna a Tavola, un restaurant à l'ancienne avec son ambiance particulière et ses énormes assiettes de cuisine sarde avec des recettes très originales."
        )
    ]*/
    
    var data:[Article] = []

    
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
        var profileImageTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        if offset < 0 {
            
            let coverImageScaleFactor:CGFloat = -(offset) / header.bgImageView.bounds.height
            
            let coverImageSizevariation = ((header.bgImageView.bounds.height * (1.0 + coverImageScaleFactor)) - header.bgImageView.bounds.height)/2.0
            
            coverImageTransform = CATransform3DTranslate(coverImageTransform, 0, coverImageSizevariation, 0)
            
            coverImageTransform = CATransform3DScale(coverImageTransform, 1.0 + coverImageScaleFactor, 1.0 + coverImageScaleFactor, 0)
            
            profileImageTransform = CATransform3DTranslate(profileImageTransform, 0, -offset, 0)
            
        } else {
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset, -headerInset + 150), 0)
            
            let profileImageScaleFactor:CGFloat = -(offset) / (-headerInset + 20)
            
            profileImageTransform = CATransform3DScale(profileImageTransform, max(0.4, 1.0 - profileImageScaleFactor), max(0.4, 1.0 - profileImageScaleFactor), 0)
            

            if offset <= (headerInset - 150) {
                
                if header.layer.zPosition < tableView.layer.zPosition{
                    tableView.layer.zPosition = 0
                }
                
            } else {
                if header.layer.zPosition >= tableView.layer.zPosition{
                    header.layer.zPosition = 2
                }
            }
            
        }
        
        header.layer.transform = headerTransform
        header.bgImageView.layer.transform = coverImageTransform
        header.profileImageView.layer.transform = profileImageTransform
        
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "authorDescCell")! as UITableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "authorArticleCell")! as! AuthorArticleCell
            
            cell.coverImageView.image = UIImage(named: data[indexPath.row-1].cover!)
            
            //cell.categorieLabel.text = data[indexPath.row-1].category.title.uppercased()
            cell.titleLabel.text = data[indexPath.row-1].title.uppercased()
            cell.descriptionLabel.text = data[indexPath.row-1].desc
            
            return cell
        }
        
        
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
