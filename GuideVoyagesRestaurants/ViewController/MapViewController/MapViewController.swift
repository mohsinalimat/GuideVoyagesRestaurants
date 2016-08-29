//
//  MapViewController.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 06/08/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import MapKit
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    var hotels:[Hotel] = []
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for hotel in hotels {
            
            let pinLocation = CLLocationCoordinate2DMake(CLLocationDegrees(hotel.latitude!), CLLocationDegrees(hotel.longitude!))
            
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = pinLocation
            dropPin.title = hotel.nom.uppercaseString
            dropPin.subtitle = "Par Frédéric Lacroix".uppercaseString
            mapView.addAnnotation(dropPin)
            
        }
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "ItemAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let button = UIButton(type: UIButtonType.DetailDisclosure) as UIButton
            annotationView?.rightCalloutAccessoryView = button
            
        } else {
            annotationView!.annotation = annotation
        }
        
        //configureDetailView(annotationView!)
        
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
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let articleViewController = ArticleViewController(nibName: "ArticleViewController", bundle: nil)
        self.navigationController?.pushViewController(articleViewController, animated: true)
        
    }
    
    func configureDetailView(annotationView: MKAnnotationView) {
        let width = 300
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
        
        annotationView.detailCalloutAccessoryView = snapshotView
    }

    
    /*func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Don't want to show a custom image if the annotation is the user's location.
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            
            // Resize image
            let pinImage = UIImage(named: "travel.png")
            let size = CGSize(width: 30, height: 30)
            UIGraphicsBeginImageContext(size)
            pinImage!.drawInRect(CGRectMake(0, 0, size.width, size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            annotationView.image = resizedImage
        }
        
        return annotationView
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - MKMapView
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        /*        
        var mapRegion = MKCoordinateRegion()
        mapRegion.center = mapView.userLocation.coordinate
        mapRegion.span.latitudeDelta = 0.1
        mapRegion.span.longitudeDelta = 0.1
        
        mapView.setRegion(mapRegion, animated: true)
        */
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
