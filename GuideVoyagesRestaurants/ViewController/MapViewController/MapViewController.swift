//
//  MapViewController.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 06/08/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import MapKit
import UIKit
import DistancePicker

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var distancePicker: DistancePicker!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var searchRadiusOverlay: MKOverlay?
    var searchRadiusActive: Bool {
        return distancePicker.selectedValue != DBL_MAX && isValidAuthorizationStatus(status: authorizationStatus)
    }
    var authorizationStatus = CLAuthorizationStatus.notDetermined
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        distancePicker.target = self
        distancePicker.action = #selector(updateUI)
        distancePicker.backgroundColor = bgColor
        distancePicker.tintColor = mainColor
        distancePicker.usesMetricSystem = false
        
        mapView.delegate = self
        mapView.isHidden = true
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 30
        
        /*for hotel in hotels! {
         
         let pinLocation = CLLocationCoordinate2DMake(CLLocationDegrees(hotel.latitude!), CLLocationDegrees(hotel.longitude!))
         
         let dropPin = MKPointAnnotation()
         dropPin.coordinate = pinLocation
         dropPin.title = hotel.nom.uppercased()
         dropPin.subtitle = "Par Frédéric Lacroix".uppercased()
         mapView.addAnnotation(dropPin)
         
         }*/
        
    }
    
    func popToRoot(_ sender:UIBarButtonItem){
        self.navigationController!.popViewController(animated: true)
    }
    
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
    
    // MARK: - Updating UI
    
    func updateUI() {
        updateSearchRadiusOverlay()
        updateVisibleMapRect()
    }
    
    func updateSearchRadiusOverlay() {
        if let overlay = searchRadiusOverlay {
            mapView.remove(overlay)
            searchRadiusOverlay = nil
        }
        
        if searchRadiusActive {
            searchRadiusOverlay = MKCircle(center: mapView.userLocation.coordinate,
                                           radius: distancePicker.selectedValue)
            mapView.add(searchRadiusOverlay!)
        }
    }
    
    func updateVisibleMapRect() {
        if searchRadiusActive {
            let overlayInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            let mapRect = mapView.mapRectThatFits(searchRadiusOverlay!.boundingMapRect, edgePadding: overlayInset)
            
            mapView.setVisibleMapRect(mapRect, animated: false)
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
    
    private func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            
            circle.strokeColor = UIColor.red
            circle.fillColor = UIColor.red.withAlphaComponent(0.1)
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
        
        let identifier = "ItemAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let button = UIButton(type: UIButtonType.detailDisclosure) as UIButton
            annotationView?.rightCalloutAccessoryView = button
            
        } else {
            annotationView!.annotation = annotation
        }
        
        
        
        let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: annotationView!.frame.size.width, height: annotationView!.frame.size.height - 10.0)))
        
        imageView.image = UIImage(named: "1.jpg")
        
        annotationView?.leftCalloutAccessoryView = imageView
        annotationView?.tintColor = mainColor
        
        
        /*let label = UILabel()
        label.text = "Le titre de l'article"
        label.font = UIFont(name: "Reglo-Bold", size: 14)
        label.textColor = mainColor
        
        if #available(iOS 9.0, *) {
            annotationView?.detailCalloutAccessoryView = label
        } else {
            annotationView?.leftCalloutAccessoryView = label
        }*/
        
        
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        /*let articleViewController = ArticleViewController(nibName: "ArticleViewController", bundle: nil)
        self.navigationController?.pushViewController(articleViewController, animated: true)*/
        
    }
    
    func configureDetailView(_ annotationView: MKAnnotationView) {
        
        /*let width = 300
        let height = 200
        
        let snapshotView = UIView()
        let views = ["snapshotView": snapshotView]
        snapshotView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[snapshotView(300)]", options: [], metrics: nil, views: views))
        snapshotView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[snapshotView(200)]", options: [], metrics: nil, views: views))
        
        let options = MKMapSnapshotOptions()
        options.size = CGSize(width: width, height: height)
        
        options.mapType = .SatelliteFlyover
        
        options.camera = MKMapCamera(lookingAtCenterCoordinate: annotationView.annotation!.coordinate, fromDistance: 250, pitch: 65, heading: 0)
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.startWithCompletionHandler { snapshot, error in
            if snapshot != nil {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                imageView.image = snapshot!.image
                snapshotView.addSubview(imageView)
            }
        }
        
        annotationView.detailCalloutAccessoryView = snapshotView*/
        
    }
    
    // MARK: - UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell")! as UITableViewCell
        
        /*cell.contentView.backgroundColor = UIColor.clear
        
        let whiteRoundedView = UIView(frame: CGRect(x: 8.0, y: 8.0, width: cell.frame.width - 16.0, height: cell.frame.height - 16.0))
        
        whiteRoundedView.layer.cornerRadius = 10.0
        whiteRoundedView.backgroundColor = highlightColor
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)*/
        /*let cell = UITableViewCell()
        
        cell.textLabel?.text = "Salut"
        cell.textLabel?.textColor = mainColor
        
        cell.backgroundColor = bgColor*/
        
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - MKMapView
    
    /*func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        
        var mapRegion = MKCoordinateRegion()
        mapRegion.center = mapView.userLocation.coordinate
        mapRegion.span.latitudeDelta = 0.1
        mapRegion.span.longitudeDelta = 0.1
        
        mapView.setRegion(mapRegion, animated: true)
        
    }*/

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
