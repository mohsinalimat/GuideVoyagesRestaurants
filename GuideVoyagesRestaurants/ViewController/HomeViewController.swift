//
//  HomeViewController.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 04/08/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    let type:[Category] = [Category(id: 0, title: "accueil"), Category(id: 1, title: "restaurant"), Category(id: 2, title: "voyage"), Category(id: 3, title: "hotel"), Category(id: 4, title: "recette"), Category(id: 5, title: "shopping")]
    var selectedCategorie: Int = 0
    
    var hotels:[Hotel]?
    
    var searchController: UISearchController!
    
    var refreshControl: UIRefreshControl!
    var ref:FIRDatabaseReference?
    
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

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var animatingImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    
        self.animate()
        /*-------------------
        FIREBASE CONNECTION
        -------------------*/
        
        /*self.ref = FIRDatabase.database().reference().child("2")
        
        ref!.queryLimitedToFirst(100).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            var data:[Hotel] = []
            
            for item in snapshot.children {
                let hotel = Hotel(snapshot: item as! FIRDataSnapshot)
                data.append(hotel)
            }
            
            self.hotels = data
            self.tableView.reloadData()
            self.loadingView.hidden = true
            
        }) { (error) in
            print(error.localizedDescription)
        }*/
        
        
        self.loadingView.hidden = true
        
        
        self.view.backgroundColor = bgColor
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        // Setup Navigation items :
        var btnName = UIButton()
        btnName.setImage(UIImage(named: "localisation"), forState: .Normal)
        btnName.addTarget(self, action: #selector(self.showMapView), forControlEvents: .TouchDown)
        btnName.frame = CGRectMake(0, 0, 22, 22)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = btnName
        
        
        btnName = UIButton()
        btnName.setImage(UIImage(named: "recherche"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 22, 22)
        btnName.addTarget(self, action: #selector(self.searchClick), forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        
        
        btnName = UIButton(type: UIButtonType.Custom)
        btnName.setImage(UIImage(named: "back"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 22, 22)
        let backBarButton = UIBarButtonItem()
        backBarButton.customView = btnName
        
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        
        
        // Add scrollViewContainer
        let scrollViewContainer = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: scrollView.bounds.width, height: scrollView.bounds.height)))
        
        var offsetX: CGFloat = 5
        
        var button: UIButton
        
        for item in type {
            
            button = UIButton(frame: CGRect(origin: CGPoint(x: offsetX, y:5), size: CGSize(width: scrollView.bounds.height - 10.0, height: scrollView.bounds.height - 10.0)))
            
            button.addTarget(self, action: #selector(self.changePage), forControlEvents: UIControlEvents.TouchUpInside)
            button.setTitle(item.title.uppercaseString, forState: .Normal)
            button.setTitleColor(mainColor, forState: .Normal)
            
            button.layer.cornerRadius = 10.0
            
            button.titleLabel?.font = UIFont(name: "Reglo-Bold", size: 10)
            
            if item.id == selectedCategorie {
                button.backgroundColor = highlightColor
            }
            
            
            /*button.layer.borderWidth = 0.8
             button.layer.borderColor = UIColor(red:0.11, green:0.27, blue:0.52, alpha:1.0).CGColor*/
            
            
            button.setImage(UIImage(named: item.title), forState: .Normal)
            //button.setBackgroundImage(UIImage(named: icon[i]), forState: .Normal)
            
            button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 25, right: 15)
            button.titleEdgeInsets = UIEdgeInsets(top: 55, left: -256, bottom: 0, right: 0)
            
            button.tintColor = mainColor
            button.tag = item.id
            
            scrollViewContainer.addSubview(button)
            
            offsetX += scrollView.bounds.height - 5.0
            
        }
        
        scrollViewContainer.backgroundColor = bgColor
        
        var frame : CGRect = scrollViewContainer.frame
        frame.size.width = offsetX
        scrollViewContainer.frame = frame

        
        scrollView.addSubview(scrollViewContainer)
        
        
        scrollView.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Leading, relatedBy: .Equal, toItem: scrollViewContainer, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        scrollView.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Trailing, relatedBy: .Equal, toItem: scrollViewContainer, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        scrollView.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: scrollViewContainer, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        scrollView.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Top, relatedBy: .Equal, toItem: scrollViewContainer, attribute: .Top, multiplier: 1.0, constant: 0.0))
        
        
        
        
        
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Rechercher ici..."
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        
        /*refreshControl = UIRefreshControl()
        
        // Custom Refresh View
        let refreshContents = NSBundle.mainBundle().loadNibNamed("CustomRefreshView", owner: self, options: nil)
        let refreshView = refreshContents[0] as! UIView
        refreshView.frame = refreshControl.bounds
        refreshControl.addSubview(refreshView)
        
        tableView.addSubview(refreshControl)*/
        
    }
    
    func searchClick(sender: UIButton) {
        
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.titleView = searchController.searchBar
        searchController.searchBar.delegate = self
        self.searchController.searchBar.becomeFirstResponder()
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {

        self.navigationItem.titleView = nil
        self.navigationItem.title = "Guide Voyages & Restaurants"

        var btnName = UIButton()
        btnName.setImage(UIImage(named: "localisation"), forState: .Normal)
        btnName.addTarget(self, action: #selector(self.showMapView), forControlEvents: .TouchDown)
        btnName.frame = CGRectMake(0, 0, 22, 22)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = btnName
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        btnName = UIButton()
        btnName.setImage(UIImage(named: "recherche"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 22, 22)
        btnName.addTarget(self, action: #selector(self.searchClick), forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = rightBarButton
        
       

    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
    }
    
    
    func animate() {
        if !self.loadingView.hidden {
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                self.animatingImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
                
                }, completion: { (finished) -> Void in
                    
                    UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                        
                        self.animatingImage.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_4))
                        
                        }, completion: { (finished) -> Void in
                            self.animate()
                    })
            })
        }
    }
    
    func showMapView(sender: UIButton) {
        let mapViewController = MapViewController(nibName: "MapViewController", bundle: nil)
        
        mapViewController.hotels = self.hotels
        
        self.navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    func changePage(sender: UIButton) {
        
        selectedCategorie = sender.tag
        
        for button in self.scrollView.subviews[0].subviews {
            if button.tag == selectedCategorie {
                button.backgroundColor = highlightColor
            } else {
                button.backgroundColor = UIColor.clearColor()
            }
        }
        
    }
    
    // MARK : TableView
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let view = tableView.dequeueReusableCellWithIdentifier("sectionCell") as! SectionCell
        
        view.title.text = data[section].title.uppercaseString
        view.author.text = "PAR " + (data[section].author?.uppercaseString)!
        view.categoryTitle.text = data[section].category.title.uppercaseString
        
        return view
        
        /*if let _ = hotels {
        
            let view = tableView.dequeueReusableCellWithIdentifier("sectionCell") as! SectionCell
            
            view.title.text = data[section].title.uppercaseString
            view.author.text = "PAR " + (data[section].author?.uppercaseString)!
            view.categoryTitle.text = data[section].category.title.uppercaseString
            
            /*view.title.text = hotels![section].nom
            view.author.text = "PAR FRédéric LACROIX".uppercaseString
            view.categoryTitle.text = "HOTEL"*/
            
            
            return view
            
        } else {
            return UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 0, height: 0)))
        }*/
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //return data.count
        
        /*if let _ = hotels {
            return hotels!.count
        } else {
            return 0
        }*/
        
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
        
        
        /*let cover = UIImage(named: data[0].cover!)
        
        cell.imageMain.clipsToBounds = true
        cell.imageMain.image = cover
        cell.descText.text = data[0].desc!*/
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let articleViewController = NewArticleViewController(nibName: "NewArticleViewController", bundle: nil)
        self.navigationController?.pushViewController(articleViewController, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

