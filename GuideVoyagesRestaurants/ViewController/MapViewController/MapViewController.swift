//
//  MapViewController.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 06/08/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import MapKit
import UIKit
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var distancePickerControl: DistancePickerControl!
    
    var searchRadiusOverlay: MKOverlay?
    var searchRadiusActive: Bool {
        //return distancePickerControl.distance != DBL_MAX && isValidAuthorizationStatus(status: authorizationStatus)
        return isValidAuthorizationStatus(status: authorizationStatus)
    }
    var authorizationStatus = CLAuthorizationStatus.notDetermined
    var locationManager = CLLocationManager()
    var locValue:CLLocationCoordinate2D? = nil
    
    var data:[Article] = []
    
    var isLoadingMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = bgColor
        
        // Do any additional setup after loading the view.
        
        var btnName = UIButton()
        btnName = UIButton(type: UIButtonType.custom)
        btnName.setImage(UIImage(named: "back"), for: UIControlState())
        btnName.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        btnName.addTarget(self, action: #selector(self.popToRoot), for: .touchDown)
        let backBarButton = UIBarButtonItem()
        backBarButton.customView = btnName
        
        self.navigationItem.leftBarButtonItem = backBarButton
        self.navigationItem.title = "Autour de vous"
        
        
        // Setting Distance Picker
        distancePickerControl = DistancePickerControl(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 60.0))
        distancePickerControl.target = self
        distancePickerControl.action = #selector(updateUI)
        self.view.addSubview(distancePickerControl)
        
        mapView.delegate = self
        mapView.isHidden = true
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 30
        
    }
    
    func popToRoot(_ sender:UIBarButtonItem){
        self.navigationController!.popViewController(animated: true)
    }
    
    
    
    // MARK: - CLLocationManager
    
    func isValidAuthorizationStatus(status: CLAuthorizationStatus) -> Bool {
        // For iOS 7, AuthorizedAlways corresponds to Authorized
        return status == CLAuthorizationStatus.authorizedWhenInUse || status == CLAuthorizationStatus.authorizedAlways
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        
        if isValidAuthorizationStatus(status: status) {
            mapView.showsUserLocation = true
        }
        updateUI()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locValue = manager.location?.coordinate
    }
    
    
    
    // MARK: - Updating UI
    
    func updateUI() {
        updateSearchRadiusOverlay()
        updateVisibleMapRect()
        loadArticles()
    }
    
    func loadPins() {
        
        mapView.removeAnnotations(mapView.annotations)
        
        var index = 0
        
        for article in data {
            let pinLocation = CLLocationCoordinate2DMake(CLLocationDegrees(article.latitude!), CLLocationDegrees(article.longitude!))
            
            let articlePin = ArticleAnnotation(id: index)
            articlePin.coordinate = pinLocation
            articlePin.title = article.title.uppercased()
            articlePin.subtitle = article.author?.uppercased()
            mapView.addAnnotation(articlePin)
            
            index += 1
        }
        
        self.tableView.reloadData()
        
        
    }
    
    func loadArticles() {
        
        if let longitude = self.locValue?.longitude, let latitude = self.locValue?.latitude {
            self.isLoadingMore = true
            
            Alamofire.request("http://www.guide-restaurants-et-voyages-du-monde.com/api/get/location/all/0/100/\(latitude)-\(longitude)-\(self.distancePickerControl.distance)").responseJSON { response in
                
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    if let articles = json["data"].array {
                        
                        self.data = []
                        
                        for row in articles {
                            if let id = row["article_id"].string, let title = row["titre"].string, let author = row["auteur"].string, let cover = row["urlphoto"].string, let desc =  row["introduction"].string, let date = row["date"].string, let category = row["categorie"].string, let latitude = row["latitude"].string, let longitude = row["longitude"].string, let distance = row["distance"].string {
                                
                                self.data.append(Article(id: id, category: category, title: title, author: author, cover: cover, desc: desc, date: date, longitude: Double(longitude), latitude: Double(latitude), distance: Double(distance)))
                                
                            }
                        }
                        
                        self.isLoadingMore = false
                        
                        DispatchQueue.main.async {
                            self.loadPins()
                        }
                    }
                }
            }
        }
    }
    
    func updateSearchRadiusOverlay() {
        if let overlay = searchRadiusOverlay {
            mapView.remove(overlay)
            searchRadiusOverlay = nil
        }
        
        if searchRadiusActive {
            
            searchRadiusOverlay = MKCircle(center: mapView.userLocation.coordinate,
                                           radius: Double(distancePickerControl.distance*1000))
            
            mapView.add(searchRadiusOverlay!, level: MKOverlayLevel.aboveLabels)
            //mapView.add(searchRadiusOverlay!)
        }
    }
    
    func updateVisibleMapRect() {
        
        if searchRadiusActive {
            let overlayInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            let mapRect = mapView.mapRectThatFits(searchRadiusOverlay!.boundingMapRect, edgePadding: overlayInset)
            
            mapView.setVisibleMapRect(mapRect, animated: true)
        }
        else if isValidAuthorizationStatus(status: authorizationStatus) {
            mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        }
        
        // On launch, hide the map until we know the user location, otherwise
        // the map is briefly centered on another location.
        mapView.isHidden = false
    }
    
    
    // MARK: - MKMapView
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        updateUI()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            
            circle.strokeColor = mainColor
            circle.fillColor = mainColor.withAlphaComponent(0.1)
            circle.lineWidth = 1
            
            return circle
        }
        else {
            fatalError("Unexpected overlay type")
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        if annotation is ArticleAnnotation {
            
            if let articleAnnotation = annotation as? ArticleAnnotation {
                
                let identifier = "ArticleAnnotation"
                
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
                
                if annotationView == nil {
                    
                    annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true
                    annotationView?.tintColor = mainColor
                    annotationView?.pinTintColor = mainColor
                    let button = UIButton(type: UIButtonType.detailDisclosure) as UIButton
                    annotationView?.rightCalloutAccessoryView = button
                    
                } else {
                    annotationView!.annotation = annotation
                }
                
                
                
                let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: annotationView!.frame.size.width, height: annotationView!.frame.size.height - 10.0)))
                
                imageView.image = UIImage(named: "1.jpg")
                
                annotationView?.leftCalloutAccessoryView = imageView
                annotationView?.tag = articleAnnotation.id
                
                return annotationView
            }
        }
        
        return nil
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let articleViewController = storyboard?.instantiateViewController(withIdentifier: "articleViewController") as? ArticleViewController {
            
            articleViewController.article = data[view.tag]
            
            self.navigationController?.pushViewController(articleViewController, animated: true)
        }
        
    }
    
    
    // MARK: - UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    /*func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 4.0))
        
        return view
    }*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mapViewArticleCell") as! MapViewArticleCell
        
        
        cell.categorieLabel.text = data[indexPath.row].category.uppercased()
        cell.titleLabel.text = data[indexPath.row].title
        cell.dateLabel.text = data[indexPath.row].date
        
        if var distance = data[indexPath.row].distance {
            
            if distance >= 1 {
                
                distance = round(distance*100)/100
                cell.distanceLabel.text = "à \(distance.description) km"
            } else {
                
                distance = round(distance*1000)
                cell.distanceLabel.text = "à \(distance.description) m"
                
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let articleViewController = storyboard?.instantiateViewController(withIdentifier: "articleViewController") as? ArticleViewController {
            
            articleViewController.article = data[indexPath.row]
            
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
