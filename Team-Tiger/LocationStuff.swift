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
    
    public func sortWithDistance(array: [String : AnyObject]) -> [String : AnyObject] {
        var arrayCopy = array
        var closestCoordinate = CLLocation()
        let coordinates = array["coordinates"] as? Array<CLLocation>
        //        closestCoordinate = coordinates![0]
        
        var latitudeTotal = 0.0
        var longitudeTotal = 0.0
        var totalCount = Double((coordinates!.count))
        for coordinate in coordinates! {

            latitudeTotal = latitudeTotal + coordinate.coordinate.latitude
            longitudeTotal = longitudeTotal + coordinate.coordinate.longitude
            
        }
        closestCoordinate = CLLocation(latitude: latitudeTotal/totalCount, longitude: longitudeTotal/totalCount)
        arrayCopy["coordinates"] = closestCoordinate

        return arrayCopy
    }
    
    public func makeCoordinatesIntoArray(parks: AnyObject) -> Array<CLLocation> {
        
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
            
        } else {
            return parks as! Array<CLLocation>
        }
    }
}


