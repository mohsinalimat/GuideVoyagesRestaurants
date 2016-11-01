//
//  HomeViewController.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 04/08/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import SVPullToRefresh
import HMSegmentedControl

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    var searchController: UISearchController!
    
    var refreshControl: UIRefreshControl!
    
    var data:[Article] = []
    
    var isLoadingMore = false // flag
    
    var categorie:String = "all"
    
    let categoriesName:[String] = ["all", "restaurants", "voyages", "shopping", "gastronomie", "bonus"]

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = bgColor
        
        
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
        
        
        // Categorie Header
        let menuControl = HMSegmentedControl(sectionTitles: ["ACCUEIL", "RESTAURANT", "VOYAGE", "SHOPPING", "GASTRONOMIE", "BONUS"])
        menuControl?.frame = CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: 40.0)
        menuControl?.addTarget(self, action: #selector(self.controlValueChanged), for: .valueChanged)
        //menuControl?.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
        menuControl?.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        menuControl?.titleTextAttributes = [
            NSFontAttributeName : UIFont(name: "Reglo-Bold", size: 15)!,
            NSForegroundColorAttributeName : mainColor
        ]
        menuControl?.backgroundColor = bgColor
        menuControl?.selectionIndicatorColor = mainColor
        menuControl?.segmentEdgeInset = UIEdgeInsetsMake(0, 5.0, 0, 5.0)
        view.addSubview(menuControl!)
        
        
        
        // Setting up Search Controller
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Rechercher ici..."
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        
        
        
        // Custom Refresh View
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshArticles), for: UIControlEvents.valueChanged)
        let refreshView:LoadingView = LoadingView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: refreshControl.bounds.height))
        refreshView.updateSize(width: 55/2, height: 25/2)
        refreshControl.addSubview(refreshView)
        
        let tableViewController = UITableViewController()
        tableViewController.tableView = tableView
        tableViewController.refreshControl = refreshControl
        
        // Setup TableView :
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 50
        
        /*tableView.rowHeight = 400
        tableView.sectionHeaderHeight = 60*/
        
        self.tableView.register(UINib(nibName: "ArticleHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "articleHeader")
        
        self.loadArticles(from: 0, number: 10, refresh: true)
        
        
        self.tableView.addInfiniteScrolling {
            self.loadMore(count: 5)
        }
        
    }
    
    func controlValueChanged(control: HMSegmentedControl) {
        self.categorie = categoriesName[control.selectedSegmentIndex]
        self.loadArticles(from: 0, number: 10, refresh: true)
    }
    
    func refreshArticles() {
        if !isLoadingMore {
            self.loadArticles(from: 0, number: 5, refresh: true)
        }
    }
    
    func loadArticles(from: Int, number: Int, refresh: Bool) {
        
        self.isLoadingMore = true
        
        Alamofire.request("http://www.guide-restaurants-et-voyages-du-monde.com/api/get/last/\(categorie)/\(from)/\(number)").responseJSON { response in
            
            if let value = response.result.value {
                let json = JSON(value)
                
                if let articles = json["data"].array {
                    
                    if refresh {
                        self.data = []
                    }
                    
                    for row in articles {
                        if let id = row["article_id"].string, let title = row["titre"].string, let author = row["auteur"].string, let cover = row["urlphoto"].string, let desc =  row["introduction"].string, let date = row["date"].string, let category = row["categorie"].string, let latitude = row["latitude"].string, let longitude = row["longitude"].string {
                            
                            self.data.append(Article(id: id, category: category, title: title, author: author, cover: cover, desc: desc, date: date, longitude: Double(longitude), latitude: Double(latitude)))
                            
                        }
                    }
                    
                    
                    
                    DispatchQueue.main.async {
                        
                        self.tableView.reloadData()
                        
                        
                        
                        if (self.refreshControl != nil) {
                            self.refreshControl.endRefreshing()
                        }
                    }
                    
                    self.isLoadingMore = false
                }
            }
        }
    }
    
    func loadMore(count: Int) {
        
        let from = self.data.count - 1
        
        Alamofire.request("http://www.guide-restaurants-et-voyages-du-monde.com/api/get/last/\(categorie)/\(self.data.count)/\(count)").responseJSON { response in
            
            if let value = response.result.value {
                let json = JSON(value)
                
                if let articles = json["data"].array {
                    
                    for row in articles {
                        if let id = row["article_id"].string, let title = row["titre"].string, let author = row["auteur"].string, let cover = row["urlphoto"].string, let desc =  row["introduction"].string, let date = row["date"].string, let category = row["categorie"].string, let latitude = row["latitude"].string, let longitude = row["longitude"].string {
                            
                            self.data.append(Article(id: id, category: category, title: title, author: author, cover: cover, desc: desc, date: date, longitude: Double(longitude), latitude: Double(latitude)))
                            
                        }
                    }
                    
                    
                    let indexSection:IndexSet = IndexSet(integersIn: from..<(from+count))
                    
                    self.tableView.beginUpdates()
                    self.tableView.insertSections(indexSection, with: UITableViewRowAnimation.fade)
                    self.tableView.endUpdates()
                    
                    self.tableView.infiniteScrollingView.stopAnimating()
                    
                }
            }
        }
    }

    
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
    }
    
    // MARK : TableView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "articleHeader") as! ArticleHeader
        
        view.categoryTitle.text = data[section].category.uppercased()
        view.title.text = data[section].title.uppercased()
        view.author.text = "PAR " + (data[section].author?.uppercased())!
        view.dateLabel.text = data[section].date
        
        return view
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell") as! ArticleCell
        
        cell.imageMain.sd_setImage(with: URL(string: data[indexPath.section].cover!))
        cell.descText.text = data[indexPath.section].desc!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let articleViewController = storyboard?.instantiateViewController(withIdentifier: "articleViewController") as? ArticleViewController {
            
            articleViewController.article = data[indexPath.section]
            
            self.navigationController?.pushViewController(articleViewController, animated: true)
        }
        
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

