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
import CoreData

class LocationStuff: NSObject, CLLocationManagerDelegate {
    
    let dataStore = DataStore.store

    // Move to viewDidLoad
    
    public func sortWithDistance(array: [String : AnyObject], location: CLLocation) -> (closest: CLLocation, distance: Double) {
//        var arrayCopy = array
//        print(dataStore.currentLocation)
        var closestCoordinate = CLLocation()
        if let coordinates = array["coordinate"] as? Array<CLLocation> {
            //        for dictionary in array {
            closestCoordinate = coordinates[0]
            
            for coordinate in coordinates {
                print("\(coordinate.coordinate) is this far away \(coordinate.distanceFromLocation(location))")
                if coordinate.distanceFromLocation(location) < closestCoordinate.distanceFromLocation(location) {
                    closestCoordinate = coordinate
                }
            }
            
            //            var dictionaryCopy = dictionary
            //            arrayCopy.append(dictionaryCopy)
//            arrayCopy.updateValue(closestCoordinate, forKey: "Closest Coordinate")
//            arrayCopy.updateValue(closestCoordinate.distanceFromLocation(location), forKey: "Distance from User's Location")
//            print(closestCoordinate)
        }
        return (closest: closestCoordinate, distance: closestCoordinate.distanceFromLocation(location))
    }
    
    public func makeCoordinatesIntoArray(parks: AnyObject) -> Array<CLLocation> {
        
//        print("called")
        if parks.containsString("MULTIPOLYGON") {
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

        return parksCopy
        }
        else {
            return parks as! Array<CLLocation>
        }
    }
    
    
}


