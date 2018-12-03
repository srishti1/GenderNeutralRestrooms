//
//  currentLocation.swift
//  GenderNeutralRestrooms
//
//  Created by Srishti on 02/12/18.
//  Copyright © 2018 Srishti Miglani. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class currentLocation: NSObject ,CLLocationManagerDelegate{
    
    var locationManager = CLLocationManager()
    var latitude: Double!
    var longitude: Double!
    var location: CLLocation?
    
    func findLocation(){  
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        self.locationManager = locationManager
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        location = (locations.last as! CLLocation)
        latitude =  location?.coordinate.latitude ?? 37.7710347
        longitude =  location?.coordinate.longitude ?? -122.4040795
    }
    
    
}

