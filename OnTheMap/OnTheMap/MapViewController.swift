//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Sensehack on 17/11/16.
//  Copyright © 2016 Sensehack. All rights reserved.
//

import Foundation
import MapKit

class MapViewController : UIViewController , MKMapViewDelegate {
    
    @IBOutlet weak var mapViewController: MKMapView!
    
    
    // let parsedClient = ParsingClient.sharedInstance() 
    

    
    // MARK: View Will appear
    override func viewWillAppear(_ animated: Bool) {
        
         UIApplication.shared.isNetworkActivityIndicatorVisible = true
        super.viewWillAppear(animated)
        
        ParsingClient.sharedInstance().getUserLocation(userIDUniqueKey: UserInfo.userKey) { (success, error) in
            
            if success! {
            
                    let tempLatitude = UserInfo.MapLatitude
                    let tempLongitude = UserInfo.MapLongitude
                    
                    let mapSum = tempLatitude + tempLongitude
                    // Changed Condition checking from "> 0" to "!= 0"
                    if mapSum != 0 {
                        self.performUIUpdatesOnMain {
                            let coordinateLocation = CLLocationCoordinate2D(latitude: tempLatitude, longitude: tempLongitude)
                            let coordinatesSpan = MKCoordinateSpanMake(10, 10)
                            let coordinateRegion = MKCoordinateRegion(center: coordinateLocation, span: coordinatesSpan)
                            self.mapViewController.setRegion(coordinateRegion, animated: true)
                            
                        }
                        
                            }
            }   // success if statement end
            
            else
            {
                // Console Debug Print
                print("View Will Appear Func Error Console Print")
                print(error)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.displayAlertHelper(message: error!)
            }
            
    } // success / error Check
    
        
        // Get Multiple Student Locations 
        
        
        ParsingClient.sharedInstance().getStudentsLocation() { ( success , error) in
            
            if success! {
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
                // Remove old pins & Reinitialize the map with refreshed Pins
                self.mapViewController.removeAnnotations(self.mapViewController.annotations)
                self.reinitializedPopulateMap()
            } else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.displayAlertHelper(message: error!)
            }
        
        }  // getStudentsLocation End declaration
        
    
    }  // View will appear End declaration 
    
    
    // IBACtions 
    
    // MARK: Logout Button IBAction
    
    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        UdacityClientConvenience.sharedInstance().deleteUserSession() { ( success  , error ) in
            
            if success {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                self.performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: nil)
                    
                }
            } else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.displayAlertHelper(message: error!)
            }
            
        }//  Delete USer Session End Declaration
        
    } //  Logout End Declaration
    
    
    // MARK: Refresh Button IBAction
    @IBAction func refreshButtonPressed(_ sender: AnyObject) {
        
        ParsingClient.sharedInstance().getStudentsLocation() { ( success ,error) in
            
            if success! {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
                self.performUIUpdatesOnMain {
                   self.mapViewController.removeAnnotations(self.mapViewController.annotations)
                    self.reinitializedPopulateMap()
                }
            } else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                // Console Debug Print
                print("Error Refresh Button Pressed IBACtion Console Print")
                self.displayAlertHelper(message: error!)
            }
            
        } // get Student Location End Declaration

    } // Refresh button End Declaration

    //Udacity Review Notes
   // The detail disclosure does not appear when tapping a pin so it is not possible to open the student's link. Add the code below to fix this:
    // For Opening the Pin View of Student 
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
        
    }
    
    
    
    
    // MARK: Function to ReInitialised  map with students Locations Markers
    
    func reinitializedPopulateMap(){
        
        // Store map annotations
        var annotations = [MKPointAnnotation]()
        
        for ss in StudentStructDict.sharedInstance.studentsDict {
            
            // Create coordinate from latitude and longitude
            let sslat = CLLocationDegrees(ss.latitude)
            let sslon = CLLocationDegrees(ss.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: sslat, longitude: sslon)
            
            // Create map annotation with coordinate, name and media URL
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(ss.firstName) \(ss.lastName)"
            annotation.subtitle = ss.mediaURL
            
            // Add annotation to array
            annotations.append(annotation)
        }
        
        // Add annotations to map
        mapViewController.addAnnotations(annotations)
        
    } // func reinitializedPopulateMap() end

    
    // Open links on Browsers
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Make sure URL is in correct format
        
        // Can't unwrap properly with View > annotation > Subtitle String URL.
        //let mediaURL = URL(view.annotation?.subtitle)
        // let medi = view.annotation?.subtitle
        //let mediae = URL(string: medi!)
       // let media = URL (string : (view.annotation?.subtitle)!)
        
        
        let mediaURL = URL(string: OnTheMapHelper.sharedInstance().formatURL(url: ((view.annotation?.subtitle)!)!))
       
        
        UIApplication.shared.open(mediaURL!, options: [:], completionHandler: nil)
    }
    
    
    

} // Class End declaration
