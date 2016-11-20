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
    
    
    
    
    // Outlets
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var postStatusLink: UITextField!
    // Location Studying From Label was correct , my other referencing Text Field Labels got referenced to "locationStudyingFrom" instead of "searchLocationTextField"  Silly Me.
    @IBOutlet weak var locationStudyingFrom: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var searchLocationTextField: UITextField!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var midView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var findOnMapButton: UIButton!
    
    
    
    // Configure UI based on Input given , Default Loading is MapView
    
    func configureUI(state : UIState) {
        
        if state == .MapView {
            //Set the default UI State
            self.configuredUIState = "MapView"
            mapView.isHidden = true
            findOnMapButton.isEnabled = true
            searchLocationTextField.isEnabled  = true
            postStatusLink.isHidden  = true
            findOnMapButton.setTitle("Find on the Map", for: UIControlState.normal)
            locationStudyingFrom.isEnabled = true
            cancelButton.setTitleColor(UIColor.red, for: .normal)
        }
        
        if state == .StatusURL {
            //Set the default UI State
            self.configuredUIState = "StatusURL"
            mapView.isHidden = false
            findOnMapButton.isEnabled = true
            findOnMapButton.setTitle("Update Status", for: UIControlState.normal)
            searchLocationTextField.isEnabled  = false
            postStatusLink.isHidden  = false
            locationStudyingFrom.isHidden = true
            cancelButton.setTitleColor(UIColor.green, for: .normal)
        }

    }

    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performUIUpdatesOnMain {
            
            // https Prefix for URL to be shared
            if self.postStatusLink.tag == 1 {
                self.postStatusLink.text = "https://"
            }
           
            self.configureUI(state: .MapView)
            
        }
        
    }
    
    /* 
     Commented as it doesn't serve its purpose
    // MARK: ViewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    } */
  
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
            //Network Activity visible
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            performUIUpdatesOnMain {
                
                // GeoLocator Object
                
                let geocoder  = CLGeocoder()
                
                geocoder.geocodeAddressString(self.searchLocationTextField.text!, completionHandler :{ (results , error) in
            
                    // guard statements incoming
                    
                    guard  error == nil else {
                       self.displayAlertHelper(message: "Sorry we found error while searching for the String in Geolocation Map Kit")
                        //Network Activity visible
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        return
                    }
                    
                    // Change the condition check , forgot != False == TRUE + it is guard statement which goes for else {} :)
                    //Guard statement for Results been returned
                    guard  (results?.isEmpty) == false  else {
                        self.displayAlertHelper(message: "Sorry we found error while searching for the String in Geolocation Map Kit")
                        //Network Activity visible
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
                    
            }) // Closure End Declaration
           } // Perform UI Updates End Declaration
            //Network Activity visible
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        } // Status URL configured UI  } End declaration
        
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
                //Network Activity visible
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
                    ParsingClient.sharedInstance().postUserLocation(userIDUniqueKey: UserInfo.userKey, firstName: UserInfo.firstName, lastName: UserInfo.lastName, mapString: searchLocationTextField.text!, mediaURL: self.postStatusLink.text!, latitude: self.pinplacemark!.location!.coordinate.latitude, longitude: self.pinplacemark!.location!.coordinate.longitude) { (success , error ) in
                        
                    if success {
                        self.performUIUpdatesOnMain {
                            
                            // Set user's location coordinates to center the map on when view controller is dismissed
                            UserInfo.MapLatitude = (self.pinplacemark!.location!.coordinate.latitude)
                            UserInfo.MapLongitude = (self.pinplacemark!.location!.coordinate.longitude)
                            // Also keep track of other information entered by user
                            UserInfo.MapString = self.searchLocationTextField.text!
                            UserInfo.UserURLStatus = self.postStatusLink.text!
                            
                            self.dismiss(animated: true, completion: nil)
                            
                        }
                        
                    } else {
                        
                        //Network Activity visible
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.displayAlertHelper(message: error!)
                        
                    }
                        //Network Activity visible
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            
            } // UserInfo End Object ID } Declaration
            else {
                // User is updating his Post
                
                ParsingClient.sharedInstance().updateUserLocation(userIDUniqueKey: UserInfo.userKey, objectID: UserInfo.objectID , firstName: UserInfo.firstName, lastName: UserInfo.lastName, mapString: searchLocationTextField.text!, mediaURL: self.postStatusLink.text!, latitude: self.pinplacemark!.location!.coordinate.latitude, longitude: self.pinplacemark!.location!.coordinate.longitude) { (success , error ) in
                
                    if success {
                        
                        //Network Activity visible
                        UIApplication.shared.isNetworkActivityIndicatorVisible = true
                        
                        self.performUIUpdatesOnMain {
                            
                            // Set user's location coordinates to center the map on when view controller is dismissed
                            UserInfo.MapLatitude = (self.pinplacemark!.location!.coordinate.latitude)
                            UserInfo.MapLongitude = (self.pinplacemark!.location!.coordinate.longitude)
                            // Also keep track of other information entered by user
                            UserInfo.MapString = self.searchLocationTextField.text!
                            UserInfo.UserURLStatus = self.postStatusLink.text!
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                    } else {
                        //Network Activity visible
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.displayAlertHelper(message: error!)
                        
                    } // else completion
                } // Update userlocation } completion
                
                //Network Activity visible
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            } // Else Declaration }  // User is updating his Post
  
        } // Status URL configured UI } End Declaration
        
    }  // findOnMapButtonPressed End } Declaration
    
    
    
    
    
    // MARK: Hide keyboard when return key is pressed and perform submit action
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        //Return Keyboard pressed assumes you enter the Find on Map Button.
        findOnMapButton.sendActions(for: .touchUpInside)
        return false
    }

    // MARK: Automatically prefix hyperlinks with https
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            textField.text = "https://"
        }
    }

    
       
}
