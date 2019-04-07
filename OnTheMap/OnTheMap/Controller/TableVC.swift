//
//  TableVC.swift
//  OnTheMap
//
//  Created by Ashish Chatterjee on 4/2/19.
//  Copyright © 2019 Ashish Chatterjee. All rights reserved.
//

import UIKit

class TableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return studentLocations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)

        // Configure the cell...
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        let student = studentLocations[indexPath.row]
        cell.textLabel?.text = (student.firstName ?? "") + " " + (student.lastName ?? "")
        cell.detailTextLabel?.text = student.updatedAt
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let toOpen = studentLocations[indexPath.row].mediaURL {
            UIApplication.shared.open(URL(string: toOpen)!)
        } else {
            performUIUpdatesOnMain {
                showAlert(controller: self, title: "No URL provided.", error: ErrorMessages.noURL.stringValue, actions: [okayAlertAction])
            }
        }
    }

}
