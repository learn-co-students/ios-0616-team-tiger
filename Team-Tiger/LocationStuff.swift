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
    
    public func sortWithDistance(array: [String : AnyObject], location: CLLocation) -> [String : AnyObject] {
        
        var arrayCopy = array
        var closestCoordinate = CLLocation()
        let coordinates = array["coordinates"] as? Array<CLLocation>

            closestCoordinate = coordinates![0]
            
            for coordinate in coordinates! {

                if coordinate.distanceFromLocation(location) < closestCoordinate.distanceFromLocation(location) {
                    closestCoordinate = coordinate
                }
            arrayCopy["Closest Coordinate"] = closestCoordinate
            arrayCopy["Distance"] = closestCoordinate.distanceFromLocation(location) * 0.00062137

            print(closestCoordinate)
        }
        return arrayCopy
    }
    
    public func makeCoordinatesIntoArray(parks: AnyObject) -> Array<CLLocation> {
        
//        print("called")
        if parks.containsString("MULTIPOLYGON") {
        let coordinatesCopy = String(parks.stringByReplacingOccurrencesOfString("(", withString: "")).stringByReplacingOccurrencesOfString(")", withString: "").stringByReplacingOccurrencesOfString("MULTIPOLYGON", withString: "")
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


