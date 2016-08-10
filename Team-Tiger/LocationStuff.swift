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
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    //Working code
    
    func getLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
    }
    
    // locationManager.startUpdatingLocation()
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
            //            self.currentLocation = (locationManager.location?.coordinate)!
            self.currentLocation = (locations.first)!
            self.locationManager.stopUpdatingLocation()
            print(self.currentLocation)
            
        }
    }
    
    public func sortWithDistance(array: [[String : AnyObject]], location: CLLocation) -> [[String : AnyObject]] {
        var arrayCopy = [[String : AnyObject]]()
        for dictionary in array {
            var closestCoordinate = dictionary["coordinate"]!
            let coordinates = dictionary["coordinate"] as? Array<CLLocation>
            for coordinate in coordinates! {
                print("\(coordinate.coordinate) is this far away \(coordinate.distanceFromLocation(location))")
                if coordinate.distanceFromLocation(location) < closestCoordinate.distanceFromLocation(location) {
                    closestCoordinate = coordinate
                }
            }
            var dictionaryCopy = dictionary
            arrayCopy.append(dictionaryCopy)
            dictionaryCopy.updateValue(closestCoordinate.coordinate, forKey: "Closest Coordinate")
            dictionaryCopy.updateValue(closestCoordinate.distanceFromLocation(location), forKey: "Distance from User's Location")
            
        }
        return arrayCopy
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    public func makeCoordinatesIntoArray(parks: AnyObject) -> Array<CLLocation> {
        
        print("called")
        
        var coordinatesCopy = String(parks.stringByReplacingOccurrencesOfString("(", withString: ""))
        coordinatesCopy = coordinatesCopy.stringByReplacingOccurrencesOfString(")", withString: "")
        coordinatesCopy = coordinatesCopy.stringByReplacingOccurrencesOfString("MULTIPOLYGON", withString: "")
        var locationArray = coordinatesCopy.componentsSeparatedByString(", ")
        var coordinateArray: [CLLocation] = []
        
        for locationSubset in locationArray {
            if locationSubset == locationArray[0] {
                var locationCoordinatesAsString = locationSubset.componentsSeparatedByString(" ")
                let locationCoordinates = CLLocation.init(latitude: ((locationCoordinatesAsString[2] as NSString).doubleValue), longitude: ((locationCoordinatesAsString[1] as NSString).doubleValue))
                coordinateArray.append(locationCoordinates)
                
            } else {
                
                var locationCoordinatesAsString = locationSubset.componentsSeparatedByString(" ")
                let locationCoordinates = CLLocation.init(latitude: ((locationCoordinatesAsString[1] as NSString).doubleValue), longitude: ((locationCoordinatesAsString[0] as NSString).doubleValue))
                coordinateArray.append(locationCoordinates)
            }
        }
        
        let parksCopy = coordinateArray
        print("Done")
        return parksCopy
        
    }
    
    
}


