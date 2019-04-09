//
//  TabBarVC.swift
//  OnTheMap
//
//  Created by Ashish Chatterjee on 4/4/19.
//  Copyright © 2019 Ashish Chatterjee. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        getUserLocation()
        getPins()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPins()
    }
    
    func getPins() {
        self.addButton.isEnabled = false
        self.refreshButton.isEnabled = false
        callActivityIndicator(view: self.view)
        
        ParseClient.taskForGETStudentLocation(uniqueKey: nil) { (response, error) in
            if response != nil {
                self.addButton.isEnabled = true
                self.refreshButton.isEnabled = true
                stopActivityIndicator()
                
                Students.studentLocations = (response?.StudentLocations)!
                NotificationCenter.default.post(name: .updateLocations, object: nil)
            } else {
                self.addButton.isEnabled = true
                self.refreshButton.isEnabled = true
                stopActivityIndicator()
                
                let refresh = UIAlertAction(title: "Refresh", style: .default, handler: { (action) in
                    self.getPins()
                })
                showAlert(controller: self, title: "Oops!", error: ErrorMessages.getStudentLocations.stringValue, actions: [refresh,cancelAlertAction])
            }
        }
    }
    
    func getUserLocation() {
        ParseClient.taskForGETStudentLocation(uniqueKey: Students.userData?.key) { (response, error) in
            if response != nil {
                Students.userLocation = response?.StudentLocations.first
            }
        }
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        handleAdd()
    }
    
    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        getPins()
    }
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        let confirm = UIAlertAction(title: "Logout", style: .default) { (action) in
            self.handleLogout()
        }
        showAlert(controller: self, title: "Logout?", error: ErrorMessages.confirmLogout.stringValue, actions: [confirm,cancelAlertAction])
    }
    
    func handleAdd() {
        if Students.userLocation != nil {
            let overwrite = UIAlertAction(title: "Overwrite", style: .default) { (action) in
                self.segueToAddVC()
            }
            showAlert(controller: self, title: "Location Exists", error: ErrorMessages.userLocationExists.stringValue, actions: [overwrite, cancelAlertAction])
        } else {
            segueToAddVC()
        }
    }
    
    func segueToAddVC() {
        self.performSegue(withIdentifier: "addLocation", sender: nil)
    }
    
    func handleLogout() {
        callActivityIndicator(view: self.view)
        UdacityClient.taskForDELETESession { (response, error) in
            if response != nil {
                performUIUpdatesOnMain {
                    stopActivityIndicator()
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                stopActivityIndicator()
                showAlert(controller: self, title: "Error While Logging Out", error: ErrorMessages.unsuccessfulLogout.stringValue, actions: [okayAlertAction])
            }
        }
    }
    
    @IBAction func unwindToTBVC(segue:UIStoryboardSegue) { }
    
}
