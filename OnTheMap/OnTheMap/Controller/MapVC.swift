//
//  MapVC.swift
//  OnTheMap
//
//  Created by Ashish Chatterjee on 4/2/19.
//  Copyright © 2019 Ashish Chatterjee. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    var annotations = [MKPointAnnotation]()
    var userPin: MKPinAnnotationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(loadPins), name: .updateLocations, object: nil)
    }
    
    @objc func loadPins() {
        self.map.removeAnnotations(annotations)
        annotations = [MKPointAnnotation]()
        
        for location in studentLocations {
            let lat = CLLocationDegrees(location.latitude ?? 0)
            let long = CLLocationDegrees(location.longitude ?? 0)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = location.firstName ?? ""
            let last = location.lastName ?? ""
            let mediaURL = location.mediaURL ?? ""
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = first + " " + last
            annotation.subtitle = mediaURL
            
            if location.objectId == userLocation?.objectId {
                userPin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            }
            
            annotations.append(annotation)
        }
        
        performUIUpdatesOnMain {
            self.map.addAnnotations(self.annotations)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pin = map.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pin?.canShowCallout = true
            pin?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pin?.annotation = annotation
        }
        pin?.pinTintColor = (pin?.annotation?.title == userPin?.annotation?.title) ? .udacity : .red
        
        return pin
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if view.annotation?.subtitle != nil {
                let toOpen = view.annotation?.subtitle!
                if toOpen != nil && toOpen != "" {
                    app.openURL(URL(string: toOpen!)!)
                } else {
                    showAlert(controller: self, title: "No URL provided.", error: ErrorMessages.noURL.stringValue, actions: [okayAlertAction])
                }
            }
        }
    }
    
}
