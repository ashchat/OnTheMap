//
//  AddLocationVC.swift
//  OnTheMap
//
//  Created by Ashish Chatterjee on 4/4/19.
//  Copyright © 2019 Ashish Chatterjee. All rights reserved.
//

import UIKit
import MapKit

class AddLocationVC: UIViewController {

    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var cancelButton: UIButton!
    
    var isPutRequest: Bool?
    var annotation = MKPointAnnotation()
    var locationString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeToKeyboardNotifications()
        locationTextField.delegate = self
        urlTextField.delegate = self
        map.delegate = self
        
        isPutRequest = (userLocation != nil) ? true : false
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        if locationTextField.text == "" || urlTextField.text == "" {
            showAlert(controller: self, title: "Uh oh!", error: ErrorMessages.needMoreInfo.stringValue, actions: [okayAlertAction])
        } else {
            handleSubmit()
        }
    }
    
    func handleSubmit() {
        
        let body = StudentLocationRequest(firstName: userData?.firstname, lastName: userData?.lastname, latitude: self.annotation.coordinate.latitude, longitude: self.annotation.coordinate.longitude, location: self.locationString, mediaURL: urlTextField.text, uniqueKey: userData?.key)
        let continueAlertAction = UIAlertAction(title: "Continue", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "unwindToTBVC", sender: self)
        })
        
        if isPutRequest! {
            ParseClient.taskForPUTStudentLocation(objectId: (userLocation?.objectId)!, body: body) { (response, error) in
                if response != nil {
                    performUIUpdatesOnMain {
                        showAlert(controller: self, title: "Successfully Updated Location", error: ErrorMessages.successfulLocation.stringValue, actions: [continueAlertAction])
                    }
                } else {
                    performUIUpdatesOnMain {
                        showAlert(controller: self, title: "Could Not Upload Location", error: ErrorMessages.unsuccessfulLocation.stringValue, actions: [okayAlertAction])
                    }
                }
            }
        } else {
            ParseClient.taskForPOSTStudentLocation(body: body) { (response, error) in
                if response != nil {
                    performUIUpdatesOnMain {
                        showAlert(controller: self, title: "Successfully Updated Location", error: ErrorMessages.successfulLocation.stringValue, actions: [continueAlertAction])
                    }
                } else {
                    performUIUpdatesOnMain {
                        showAlert(controller: self, title: "Could Not Upload Location", error: ErrorMessages.unsuccessfulLocation.stringValue, actions: [okayAlertAction])
                    }
                }
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        handleCancel()
    }
    
    func handleCancel() {
        let confirmAlertAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
            self.performSegue(withIdentifier: "unwindToTBVC", sender: self)
        }
        showAlert(controller: self, title: "Are you sure you want to cancel?", error: ErrorMessages.cancelAddLocation.stringValue, actions: [confirmAlertAction,cancelAlertAction])
    }
    
}

extension AddLocationVC: MKMapViewDelegate {
    
    func getLocation() {
        map.removeAnnotation(annotation)
        locationString = locationTextField.text
        callActivityIndicator(view: map)
        
        locationTextField.isEnabled = false
        
        let geocoder = CLGeocoder()
        var location: CLLocation?
        geocoder.geocodeAddressString(locationString!) { (placemarks, error) in
            guard (error == nil) else {
                stopActivityIndicator()
                showAlert(controller: self, title: "Error Geocoding.", error: ErrorMessages.geocodeError.stringValue, actions: [okayAlertAction])
                self.locationTextField.isEnabled = true
                return
            }
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            self.annotation.coordinate = (location?.coordinate)!
            self.annotation.title = self.locationString
            performUIUpdatesOnMain {
                stopActivityIndicator()
                self.locationTextField.isEnabled = true
                self.map.addAnnotation(self.annotation)
                let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                let region = MKCoordinateRegion(center: self.annotation.coordinate, span: span)
                self.map.setRegion(region, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pin = map.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pin?.canShowCallout = true
            pin?.pinTintColor = .udacity
            pin?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pin?.annotation = annotation
        }
        
        return pin
        
    }
    
}

extension AddLocationVC: UITextFieldDelegate {
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y -= 0.3*getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = UIScreen.main.bounds.origin.y
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userinfo = notification.userInfo
        let keyboardSize = userinfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getLocation()
        textField.resignFirstResponder()
        return true
    }
    
}
