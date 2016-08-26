//
//  MainTableViewController.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 06/08/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit

class MainTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let data = [
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
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300

    }
    
    // MARK : TableView
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableCellWithIdentifier("sectionCell") as! SectionCell
        
        view.title.text = data[section].title.uppercaseString
        view.author.text = "PAR " + (data[section].author?.uppercaseString)!
        view.categoryTitle.text = data[section].category.title.uppercaseString
        
        return view
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("articleCell") as! ArticleCell
        
        
        let cover = UIImage(named: data[indexPath.section].cover!)
        
        cell.imageMain.clipsToBounds = true
        cell.imageMain.image = cover
        cell.descText.text = data[indexPath.section].desc!
        
        // calculate imageViewSize :
        
        /*let aspect = cover!.size.width / cover!.size.height
         
         let aspectConstraint = NSLayoutConstraint(item: cell.imageMain, attribute:  NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: cell.imageMain, attribute: NSLayoutAttribute.Height, multiplier: aspect, constant: 0.0)
         aspectConstraint.priority = 999
         cell.addConstraint(aspectConstraint)*/
        
        
        
        /*let imageHeight = cover?.size.height
         let imageWidth = cover?.size.width
         
         let imageViewHeight = imageHeight! * screenWidth! / imageWidth!
         
         print(imageViewHeight)*/
        
        //cell.addConstraint(NSLayoutConstraint(item: cell.imageView!, attribute: NSLayoutAttribute.Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: imageViewHeight))
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
