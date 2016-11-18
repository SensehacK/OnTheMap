//
//  StudentStatusUpdate.swift
//  OnTheMap
//
//  Created by Sensehack on 17/11/16.
//  Copyright © 2016 Sensehack. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class StudentStatusUpdate : UIViewController , UITextFieldDelegate, MKMapViewDelegate {
    
    //UI view Enums
    
    enum UIState {
        case MapView , StatusURL
    }
    //Default configured UI State at first
    var configuredUIState = "MapView"
    
    var pinplacemark: CLPlacemark? = nil
    
    
    // Configure UI based on Input given , Default Loading is MapView
    
    func configureUI(state : UIState) {
        
        if state == .MapView {
            //Set the default UI State
            self.configuredUIState = "MapString"
            findOnMapButton.isEnabled = true
            searchLocationTextField.isEnabled  = true
            postStatusLink.isEnabled  = false
            
            
        }
        
        if state == .StatusURL {
            //Set the default UI State
            self.configuredUIState = "StatusURL"
            findOnMapButton.isEnabled = true
            searchLocationTextField.isEnabled  = false
            postStatusLink.isEnabled  = true
        }
        
        
        
        
    }

    
    // Outlets
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var postStatusLink: UITextField!
    @IBOutlet weak var locationStudyingFrom: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var searchLocationTextField: UITextField!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var midView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var findOnMapButton: UIButton!
    
    
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performUIUpdatesOnMain {
            
            
            self.configureUI(state: .MapView)
            
        }
        
    }
    
    // MARK: ViewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    
    
    
    
    // IBActions
    
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        
        dismiss(animated : true, completion : nil)
    }
    
    
    
    
    
    @IBAction func findOnMapButtonPressed(_ sender: AnyObject) {
        
         // MARK : Status URL configured UI 
        
        if configuredUIState == "MapView" {
            
            
            // guard checks 
            
            guard (searchLocationTextField.text?.isEmpty) != nil else {
                displayAlertHelper(message: "Please enter some Location ")
                return
            }
      // Start Geolocation Process
            
            performUIUpdatesOnMain {
                
                // GeoLocator Object
                
                let geocoder  = CLGeocoder ()
                
                geocoder.geocodeAddressString(self.searchLocationTextField.text!, completionHandler :{ (results , error) in
            
                    // guard statements incoming
                    
                    guard  error == nil else {
                       self.displayAlertHelper(message: "Sorry we found error while searching for the String in Geolocation Map Kit")
                        return
                    }

                    //Guard statement for Results been returned
                    guard  (results?.isEmpty) != false  else {
                        self.displayAlertHelper(message: "Sorry we found error while searching for the String in Geolocation Map Kit")
                        return
                    }
                    
                    self.pinplacemark = results![0]
                    self.configureUI(state: .StatusURL)
                    self.mapView.showAnnotations([MKPlacemark(placemark: self.pinplacemark!)], animated: true)
                
                    
                    // Check User Info earlier Status entries from UserInfo.swift
                    if UserInfo.UserURLStatus.isEmpty == false {
                        self.postStatusLink.text = UserInfo.UserURLStatus
                        self.findOnMapButton.setTitle("Update information", for: UIControlState.normal)
                    }
                    
            })
           }
            
        }
        
            // MARK : Status URL configured UI
        else if configuredUIState == "StatusURL" {
            
            
            // guard checks
            
            guard (postStatusLink.text?.isEmpty) != nil else {
                displayAlertHelper(message: "Please enter some status / URL ")
                return
            }

            // Check whether First time updating User Status or not ? 
            
            if UserInfo.objectID.isEmpty {
           
                //ParsingClient.sharedInstance().postUserLocation(userIDUniqueKey: UserInfo.userKey, firstName: UserInfo.firstName, lastName: UserInfo.lastName, mapString: locationStudyingFrom.text!, mediaURL: self.postStatusLink.text!, latitude: self.pinplacemark!.location!.coordinate.latitude, longitude: self.pinplacemark!.location!.coordinate.longitude) { (success ,error)
                  
                    ParsingClient.sharedInstance().postUserLocation(userIDUniqueKey: UserInfo.userKey, firstName: UserInfo.firstName, lastName: UserInfo.lastName, mapString: locationStudyingFrom.text!, mediaURL: self.postStatusLink.text!, latitude: self.pinplacemark!.location!.coordinate.latitude, longitude: self.pinplacemark!.location!.coordinate.longitude) { (success , error ) in
                        
                    if success {
                        
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        
                        performUIUpdatesOnMain {
                            
                            // Set user's location coordinates to center the map on when view controller is dismissed
                            UserInfo.MapLatitude = (self.pinplacemark!.location!.coordinate.latitude)
                            UserInfo.MapLongitude = (self.pinplacemark!.location!.coordinate.longitude)
                            // Also keep track of other information entered by user
                            UserInfo.MapString = self.locationStudyingFrom.text!
                            UserInfo.UserURLStatus = self.postStatusLink.text!
                            
                            self.dismiss(animated: true, completion: nil)
                            
                        }
                        
                    } else {
                        
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.displayAlertHelper(message: error!)
                        
                    }
                }
            
            
            } // UserInfo End Object ID } Declaration
            else {
                // User is updating his Post
                
                
                
                
            } // Else Declaration }
            
            
            
            
        }
        
        
    }
    
    
    
    
    
    // MARK: Hide keyboard when return key is pressed and perform submit action
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        //Return Keyboard pressed assumes you enter the Find on Map Button.
        findOnMapButton.sendActions(for: .touchUpInside)
        return false
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
       
}
