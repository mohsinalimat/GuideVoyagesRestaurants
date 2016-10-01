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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    let menuControl:MenuControl = MenuControl(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 60.0))
    
    var searchController: UISearchController!
    
    var refreshControl: UIRefreshControl!
    
    var data:[Article] = []
    
    var isLoadingMore = false // flag

    
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
        
        

        // Setting Menu
        menuControl.setItems(items: [MenuItem(title: "Accueil", icon: "accueil"), MenuItem(title: "Restaurant", icon: "restaurant"), MenuItem(title: "Voyage", icon: "voyage"), MenuItem(title: "Hotel", icon: "hotel"), MenuItem(title: "Recette", icon: "recette"), MenuItem(title: "Shopping", icon: "shopping")])
        menuControl.backgroundColor = bgColor
        self.view.addSubview(menuControl)
        
        
        
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
        
        self.tableView.register(UINib(nibName: "ArticleHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "articleHeader")
        
        self.loadArticles(from: 0, number: 10, refresh: true)
        
    }
    
    func refreshArticles() {
        if !isLoadingMore {
            self.loadArticles(from: 0, number: 5, refresh: true)
        }
    }
    
    func loadArticles(from: Int, number: Int, refresh: Bool) {
        
        self.isLoadingMore = true
        
        Alamofire.request("http://www.guide-restaurants-et-voyages-du-monde.com/api/get/last/all/\(from)/\(number)").responseJSON { response in
            
            if let value = response.result.value {
                let json = JSON(value)
                
                if let articles = json["data"].array {
                    
                    if refresh {
                        self.data = []
                    }
                    
                    for row in articles {
                        if let id = row["article_id"].string, let title = row["titre"].string, let author = row["auteur"].string, let cover = row["urlphoto"].string, let desc =  row["introduction"].string, let date =  row["date"].string, let category = row["categorie"].string {
                            
                            
                            self.data.append(Article(id: id, category: category, title: title, author: author, cover: cover, desc: desc, date: date))
                            
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
        
        if indexPath.section + 7 >= self.data.count {
            self.loadArticles(from: data.count, number: 10, refresh: false)
        }
        
        return cell
    }
    
    /*func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 1. set the initial state of the cell
        cell.alpha = 0.0
        
        // 2. UIView animation method to change to the final state of the cell
        
            UIView.animate(withDuration: 0.5, animations: {
                cell.alpha = 1.0
            })
        
        
        
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let articleViewController = storyboard?.instantiateViewController(withIdentifier: "articleViewController") as? ArticleViewController {
            
            articleViewController.article = data[indexPath.section]
            
            self.navigationController?.pushViewController(articleViewController, animated: true)
        }
        
    }
    
    /*func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if !isLoadingMore && (maximumOffset - contentOffset <= threshold) {
            // Get more data - API call
            self.loadArticles(from: data.count, number: 5, refresh: false, updating: true)
            
        }
        
    }*/
    

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

