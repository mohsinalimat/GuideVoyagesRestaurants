//
//  HomeViewController.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 04/08/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    let menuControl:MenuControl = MenuControl(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 60.0))
    
    let type:[Category] = [Category(id: 0, title: "accueil"), Category(id: 1, title: "restaurant"), Category(id: 2, title: "voyage"), Category(id: 3, title: "hotel"), Category(id: 4, title: "recette"), Category(id: 5, title: "shopping")]
    var selectedCategorie: Int = 0
    
    var searchController: UISearchController!
    
    var refreshControl: UIRefreshControl!
    
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

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var animatingImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = bgColor
        
        
        // Setup TableView :
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        
        // Setup Navigation items :
        var btnName = UIButton()
        btnName.setImage(UIImage(named: "localisation"), for: UIControlState())
        btnName.addTarget(self, action: #selector(self.showMapView), for: .touchDown)
        btnName.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = btnName
        
        
        btnName = UIButton()
        btnName.setImage(UIImage(named: "recherche"), for: UIControlState())
        btnName.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        btnName.addTarget(self, action: #selector(self.searchClick), for: UIControlEvents.touchUpInside)
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        
        
        btnName = UIButton(type: UIButtonType.custom)
        btnName.setImage(UIImage(named: "back"), for: UIControlState())
        btnName.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        let backBarButton = UIBarButtonItem()
        backBarButton.customView = btnName
        
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        

        // Setting Menu
        menuControl.setItems(items: [MenuItem(title: "Accueil", icon: "accueil"), MenuItem(title: "Restaurant", icon: "restaurant"), MenuItem(title: "Voyage", icon: "voyage"), MenuItem(title: "Hotel", icon: "hotel"), MenuItem(title: "Recette", icon: "recette"), MenuItem(title: "Shopping", icon: "shopping")])
        menuControl.backgroundColor = bgColor
        self.view.addSubview(menuControl)
        
        
        
        // Add scrollViewContainer
        let scrollViewContainerHeight:CGFloat = 80.0
        
        let scrollViewContainer = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width, height: scrollViewContainerHeight)))
        
        var offsetX: CGFloat = 5
        
        var button: UIButton
        
        for item in type {
            
            button = UIButton(frame: CGRect(origin: CGPoint(x: offsetX, y:5), size: CGSize(width: scrollViewContainerHeight - 10.0, height: scrollViewContainerHeight - 10.0)))
            
            button.addTarget(self, action: #selector(self.changePage), for: UIControlEvents.touchUpInside)
            button.setTitle(item.title.uppercased(), for: UIControlState())
            button.setTitleColor(mainColor, for: UIControlState())
            
            button.layer.cornerRadius = 10.0
            
            button.titleLabel?.font = UIFont(name: "Reglo-Bold", size: 10)
            
            if item.id == selectedCategorie {
                button.backgroundColor = highlightColor
            }
            
            
            
            button.setImage(UIImage(named: item.title), for: UIControlState())
            button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 25, right: 15)
            button.titleEdgeInsets = UIEdgeInsets(top: 55, left: -256, bottom: 0, right: 0)
            
            button.tintColor = mainColor
            button.tag = item.id
            
            scrollViewContainer.addSubview(button)
            
            offsetX += scrollViewContainerHeight - 5.0
            
        }
        
        scrollViewContainer.backgroundColor = bgColor
        
        var frame : CGRect = scrollViewContainer.frame
        frame.size.width = offsetX
        scrollViewContainer.frame = frame

        
        scrollView.addSubview(scrollViewContainer)
        
        
        scrollView.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: scrollViewContainer, attribute: .leading, multiplier: 1.0, constant: 0.0))
        scrollView.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .trailing, relatedBy: .equal, toItem: scrollViewContainer, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        scrollView.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: scrollViewContainer, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        scrollView.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: scrollViewContainer, attribute: .top, multiplier: 1.0, constant: 0.0))
        
        
        
        // Setting up Search Controller
        
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
        
        //self.tableView.addInfiniteScrollingWithHandler(() -> ())
        
        /*self.tableView.addInfiniteScrollingWithHandler {
            /*dispatch_async(DispatchQueue.global(DispatchQueue.GlobalQueuePriority.default, 0), { () -> Void in
                // do something in the background
                dispatch_async(dispatch_get_main_queue(), { [unowned self] in
                    self.tableView.reloadData()
                    self.tableView.infiniteScrollingView?.stopAnimating()
                    })
            })*/
        }*/
        
        Alamofire.request("http://www.guide-restaurants-et-voyages-du-monde.com/api/get/last/all/0/1").responseJSON { response in
            //print(response.request)  // original URL request
            //print(response.response) // HTTP URL response
            //print(response.data)     // server data
            //print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
        
        
        
    }
    
    /*override func viewDidLayoutSubviews() {
        menuControl.frame = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: 60.0)
    }*/
    
    func searchClick(_ sender: UIButton) {
        
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.titleView = searchController.searchBar
        searchController.searchBar.delegate = self
        self.searchController.searchBar.becomeFirstResponder()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        self.navigationItem.titleView = nil
        self.navigationItem.title = "Guide Voyages & Restaurants"

        var btnName = UIButton()
        btnName.setImage(UIImage(named: "localisation"), for: UIControlState())
        btnName.addTarget(self, action: #selector(self.showMapView), for: .touchDown)
        btnName.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = btnName
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        btnName = UIButton()
        btnName.setImage(UIImage(named: "recherche"), for: UIControlState())
        btnName.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        btnName.addTarget(self, action: #selector(self.searchClick), for: UIControlEvents.touchUpInside)
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = rightBarButton
        
       

    }
    
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    
    func showMapView(_ sender: UIButton) {
        
        if let mapViewController = storyboard?.instantiateViewController(withIdentifier: "mapViewController") as? MapViewController {
            
            self.navigationController?.pushViewController(mapViewController, animated: true)
        }
        
        //self.menuControl.setSelectedItem(item: 3)
        
        
        //mapViewController.hotels = self.hotels
        
        
    }
    
    func changePage(_ sender: UIButton) {
        
        selectedCategorie = sender.tag
        
        for button in self.scrollView.subviews[0].subviews {
            if button.tag == selectedCategorie {
                button.backgroundColor = highlightColor
            } else {
                button.backgroundColor = UIColor.clear
            }
        }
        
    }
    
    // MARK : TableView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let view = tableView.dequeueReusableCell(withIdentifier: "sectionCell") as! SectionCell
        
        view.title.text = data[section].title.uppercased()
        view.author.text = "PAR " + (data[section].author?.uppercased())!
        //view.categoryTitle.text = data[section].category.title.uppercased()
        
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return data.count
        
        /*if let _ = hotels {
            return hotels!.count
        } else {
            return 0
        }*/
        
        return data.count
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell") as! ArticleCell
        
        
        let cover = UIImage(named: data[(indexPath as NSIndexPath).section].cover!)
         
         cell.imageMain.clipsToBounds = true
         cell.imageMain.image = cover
         cell.descText.text = data[(indexPath as NSIndexPath).section].desc!
        
        
        /*let cover = UIImage(named: data[0].cover!)
        
        cell.imageMain.clipsToBounds = true
        cell.imageMain.image = cover
        cell.descText.text = data[0].desc!*/
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let articleViewController = ArticleViewController(nibName: "ArticleViewController", bundle: nil)
        self.navigationController?.pushViewController(articleViewController, animated: true)*/
        
        /*let authorViewController = AuthorViewController(nibName: "AuthorViewController", bundle: nil)
        self.navigationController?.pushViewController(authorViewController, animated: true)*/
        
        if let authorViewController = storyboard?.instantiateViewController(withIdentifier: "authorViewController") as? AuthorViewController {
            self.navigationController?.pushViewController(authorViewController, animated: true)
        }
        
        
        
    }
    
    /*let threshold:CGFloat = 100.0 // threshold from bottom of tableView
    var isLoadingMore = false // flag
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if !isLoadingMore && (maximumOffset - contentOffset <= threshold) {
            // Get more data - API call
            self.isLoadingMore = true
            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.isLoadingMore = false
            }
            
        }
        
    }*/
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

