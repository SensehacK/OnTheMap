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
    
    
    
    
    
    override func viewDidLoad() {
        <#code#>
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
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
        }
    }
    
    
}
