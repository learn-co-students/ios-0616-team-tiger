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
//    var currentLocation = CLLocation()

    override func viewDidLoad() {
        super.viewDidLoad()
        
  // Example use of ParksApiClient
//     
        
        
        let apiClient = ParksApiClient()
        
        apiClient.populateParkByTypeBasedOnState("type", type: "Mall") {
            
            // print(apiClient.typeResults)
        
        }
        let gardens = ParksApiClient().organizeParkCoordinates(apiClient.typeResults)
        print("Yay gardens! \(gardens)")
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
    
    override func viewWillAppear(animated: Bool) {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }

    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
//            print("Found user's location: \(location)")
            //            self.currentLocation = (locationManager.location?.coordinate)!
            dataStore.currentLocation = (locations.first)!
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

class PendingOperations {
    
lazy var generateParksData = [NSIndexPath:NSOperation]()
    lazy var parksQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Generate Location Queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    
}