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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
            dataStore.currentLocation = locationManager.location!
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let apiClient = ParksApiClient()
        
        apiClient.populateParkByTypeBasedOnState("type", type: "Garden") {
            //            print(apiClient.typeResults)
            let sortByDistance = NSSortDescriptor(key: "Distance", ascending: true)
            var tableViewArray : NSArray = apiClient.typeResults
            tableViewArray = tableViewArray.sortedArrayUsingDescriptors([sortByDistance])
            print("Maybe sorted \(tableViewArray)")
            
        }
        
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
               print("We know where you are")
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