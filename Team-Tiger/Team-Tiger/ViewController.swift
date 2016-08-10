//
//  ViewController.swift
//  Team-Tiger
//
//  Created by Kenneth Cooke on 8/4/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let dataStore = DataStore.store

    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
        
  // Example use of ParksApiClient
//        
        let apiClient = ParksApiClient()
        
        apiClient.populateParkByTypeBasedOnState("type", type: "Garden") {
            
            // print(apiClient.typeResults)
        
        }
        let gardens = ParksApiClient().organizeParkCoordinates(apiClient.typeResults)
        print(gardens)
//        var gardensCopy = [[String : AnyObject]]()
//        
//        for garden in gardens {
//            
//            
//            
//            var gardenCopy : [String : AnyObject] = garden
//            
//            if let coordinatesAsString = garden["coordinates"] {
//                
//                gardenCopy.updateValue(LocationStuff().makeCoordinatesIntoArray(coordinatesAsString), forKey: "coordinates")
//                
//                gardensCopy.append(gardenCopy)
//                
//                print(gardenCopy)
//                
//            }
//            
//        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
//            print("Found user's location: \(location)")
            //            self.currentLocation = (locationManager.location?.coordinate)!
            self.currentLocation = (locations.first)!
//            print(self.currentLocation)
            
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

