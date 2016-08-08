//
//  CoreLocation.swift
//  Team-Tiger
//
//  Created by Jordan Kiley on 8/8/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class LocationStuff: NSObject, CLLocationManagerDelegate {
    
    // Move to viewDidLoad
    
    //Working code
    let locationManager = CLLocationManager()
    
    func getUsersLocation()  {
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            self.locationManager.requestLocation()
        }
        let currentLocation = locationManager.location
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    
    // get coordinates from zip code, if address == user inputed zip code
    
    func getAddress(zipCode: String) -> CLLocationCoordinate2D {
        var location = CLLocationCoordinate2D()
        CLGeocoder().geocodeAddressString(zipCode, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            print(placemarks!.first?.location?.coordinate.latitude)
            print(placemarks!.first?.location?.coordinate.longitude)
            location = CLLocationCoordinate2D(latitude: (placemarks!.first?.location?.coordinate.latitude)!, longitude: (placemarks!.first?.location?.coordinate.longitude)!)
        })
        return location
    }

    
    // Works with 
    var location = "MULTIPOLYGON (((-73.94806058617907 40.755892124311735, -73.94907660291933 40.754714536732244, -73.9506676932028 40.75547896940196, -73.94837426636042 40.758290025206904, -73.94652550929953 40.75729189675534, -73.94806058617907 40.755892124311735)), ((-73.94865470013022 40.75488657292608, -73.94706791895328 40.75419745515041, -73.94536814338453 40.75345443236925, -73.943794963359 40.75278570285676, -73.94387588026277 40.752701295578525, -73.94421089685056 40.75285030922856, -73.94431454063124 40.752712248806354, -73.94503987584466 40.7530267350054, -73.9450917687084 40.75295985937953, -73.94656982153843 40.753592955296845, -73.94675774777807 40.75336947556672, -73.94823308293526 40.754010223846166, -73.94798054171468 40.75430164966184, -73.9481979338906 40.754395894584526, -73.94845596808682 40.754098130294665, -73.94857472150424 40.75414042788938, -73.94869646679601 40.754177481248945, -73.94882080377909 40.75420916861782, -73.948947325148 40.75423538714959, -73.94907561292445 40.75425605020382, -73.94916777223027 40.75429892255568, -73.94865470013022 40.75488657292608)))"
    
    func makeCoordinatesIntoArray(coordinates: String) -> Array<CLLocationCoordinate2D> {
        var coordinatesCopy = coordinates.stringByReplacingOccurrencesOfString("(", withString: "")
        coordinatesCopy = coordinatesCopy.stringByReplacingOccurrencesOfString(")", withString: "")
        coordinatesCopy = coordinatesCopy.stringByReplacingOccurrencesOfString("MULTIPOLYGON", withString: "")
        var locationArray = coordinatesCopy.componentsSeparatedByString(", ")
        var coordinateArray: [CLLocationCoordinate2D] = []
        
        for locationSubset in locationArray {
            if locationSubset == locationArray[0] {
                var locationCoordinatesAsString = locationSubset.componentsSeparatedByString(" ")
                let locationCoordinates = CLLocationCoordinate2D(latitude: ((locationCoordinatesAsString[2] as NSString).doubleValue), longitude: ((locationCoordinatesAsString[1] as NSString).doubleValue))
                coordinateArray.append(locationCoordinates)
                print("\(locationCoordinates.latitude), \(locationCoordinates.longitude)")
                
            } else {
                var locationCoordinatesAsString = locationSubset.componentsSeparatedByString(" ")
                let locationCoordinates = CLLocationCoordinate2D(latitude: ((locationCoordinatesAsString[1] as NSString).doubleValue), longitude: ((locationCoordinatesAsString[0] as NSString).doubleValue))
                coordinateArray.append(locationCoordinates)
                print("\(locationCoordinates.latitude), \(locationCoordinates.longitude)")
            }
            
        }
        return coordinateArray
    }
    
}