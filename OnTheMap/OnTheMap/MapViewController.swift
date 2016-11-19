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
    
    
    
    override func viewDidLoad() {
        <#code#>
    }
    
    // MARK: View Will appear
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        ParsingClient.sharedInstance().getUserLocation(userIDUniqueKey: UserInfo.userKey) { (success, error) in
        let tempLatitude = UserInfo.MapLatitude
        let tempLongitude = UserInfo.MapLongitude
        
        let mapSum = tempLatitude + tempLongitude
        
        if mapSum > 0 {
            performUIUpdatesOnMain {
                let coordinateLocation = CLLocationCoordinate2D(latitude: tempLatitude, longitude: tempLongitude)
                let coordinatesSpan = MKCoordinateSpanMake(10, 10)
                let coordinateRegion = MKCoordinateRegion(center: coordinateLocation, span: coordinatesSpan)
                self.mapViewController.setRegion(coordinateRegion, animated: true)
                
            }
            
        } else {
            self.displayAlertHelper(message: error!)
        }
    }
    
        
        // Get Multiple Student Locations 
        
        
        ParsingClient.sharedInstance().getStudentsLocation() { ( success , error) in
            
            if success! {
                // Remove old pins & Reinitialize the map with refreshed Pins
                self.mapViewController.removeAnnotations(self.mapViewController.annotations)
                self.reinitializedPopulateMap()
            } else {
                self.displayAlertHelper(message: error!)
            }
        
        }  // getStudentsLocation End declaration
        
    
    }  // View will appear End declaration 
    
    
    // IBACtions 
    
    // MARK: Logout Button IBAction
    
    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        UdacityClientConvenience.sharedInstance().deleteUserSession() { ( success  , error ) in
            
            if success {
                performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                self.displayAlertHelper(message: error!)
            }
            
        }//  Delete USer Session End Declaration
        
    } //  Logout End Declaration
    
    
    // MARK: Refresh Button IBAction
    @IBAction func refreshButtonPressed(_ sender: AnyObject) {
        
        ParsingClient.sharedInstance().getStudentsLocation() { ( success ,error) in
            
            if success! {
                performUIUpdatesOnMain {
                   self.mapViewController.removeAnnotations(self.mapViewController.annotations)
                    self.reinitializedPopulateMap()
                }
            } else {
                self.displayAlertHelper(message: error!)
            }
            
        } // get Student Location End Declaration

    } // Refresh button End Declaration

    
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
