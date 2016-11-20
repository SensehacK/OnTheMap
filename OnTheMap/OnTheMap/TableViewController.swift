//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Sensehack on 17/11/16.
//  Copyright © 2016 Sensehack. All rights reserved.
//

import Foundation
import UIKit

class TableViewController : UITableViewController {
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        ParsingClient.sharedInstance().getStudentsLocation() { (success, error) in
            
            if success! {
                
                // Reload table data
                self.performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
                
            } else {
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.displayAlertHelper(message: error!)
                
            }
            
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    // Set number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentStructDict.sharedInstance.studentsDict.count
    }
    
    // Configure table cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableListViewCell", for: indexPath)
        let studentTable = StudentStructDict.sharedInstance.studentsDict[indexPath.row]
        
        cell.textLabel?.text = studentTable.firstName + " " + studentTable.lastName
        cell.detailTextLabel?.text = studentTable.mapString.capitalized
        
        return cell
    }
    
    // Tap on table cell opens student's weblink
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Deselect the sElected Row as advised by Udacity Reviewer Suggestion
        tableView.deselectRow(at: indexPath, animated: true)
        
        // When a row is selected there's the following problem: 
        // Changed from customs TableCellView to Subtitle now there wont be Text overlays of Big & small Texts.
        
        
        // Make sure URL is in correct format
        if let url = URL(string: OnTheMapHelper.sharedInstance().formatURL(url: StudentStructDict.sharedInstance.studentsDict[indexPath.row].mediaURL)) {
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }
        
    }
    
    // MARK: Swipe to delete user information
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        // Check if row belongs to current user
        // This is to make sure users can only delete their own information
        
        let thisRowStudent = StudentStructDict.sharedInstance.studentsDict[indexPath.row]
        
        return thisRowStudent.uniqueKey == UserInfo.userKey
        
    } // caneditRow At end declaration
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // Identify student for this row
            let thisRowStudent = StudentStructDict.sharedInstance.studentsDict[indexPath.row]
            
            // Remove the row
            StudentStructDict.sharedInstance.studentsDict.remove(at: indexPath.row)
            
            // Remove user from Parse database
            
            ParsingClient.sharedInstance().removeUserLocation(objectID: thisRowStudent.objectID)  { (success, error) in
                
                if success! {

                    // Reset user information locally
                    // There's only one API call in map view to check whether current user has posted before
                    // So this is to keep track of things internally
                    
                    UserInfo.MapLatitude = 0.00
                    UserInfo.MapLongitude = 0.00
                    
                    UserInfo.MapString = ""
                    UserInfo.UserURLStatus = ""
                    UserInfo.objectID = ""
                    
                } else {
                    
                    
                    self.displayAlertHelper(message: error!)
                    
                }
            }
            
            performUIUpdatesOnMain {
                self.tableView.reloadData()
            }
            
        } // editing If delete ends
    }  // func TableView end declaration
    

    
    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        UdacityClientConvenience.sharedInstance().deleteUserSession() { (success ,error) in
            if success {
                
                self.performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: nil)
                    
                }
            } else {
                self.displayAlertHelper(message: error!)
            }
        }
        
    } // Func ends
    
    
    
    @IBAction func refreshButtonPressed(_ sender: AnyObject) {
        ParsingClient.sharedInstance().getStudentsLocation() { (success , error) in
            
            if success! {
                self.performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            } else {
                self.displayAlertHelper(message: error!)
            }
        }
    } // func ends
    
    
}
