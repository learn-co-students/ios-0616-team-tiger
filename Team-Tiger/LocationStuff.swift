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
//        
//        let array = makeCoordinatesIntoArray(location)
//        let newArray = sortWithDistance(array, location: self.currentLocation)
//        print(newArray)
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
        //    CLGeocoder().reverseGeocodeLocation(locations.last!,
        //                                        completionHandler: {(placemarks:[CLPlacemark]?, error:NSError?) -> Void in
        //                                            if let placemarks = placemarks {
        //                                                let placemark = placemarks[0]
        //                                                print(placemark.addressDictionary)
        //                                                print(placemark.location?.coordinate)
        //                                            }
        //    })
        
    }
    
    func sortWithDistance(dictionary: [String : Array<CLLocation>], location: CLLocation) -> [String : CLLocation] {
        let array = dictionary.values.first
        var closestCoordinate = array![0]
        
        for coordinate in array! {
            print("\(coordinate.coordinate) is this far away \(coordinate.distanceFromLocation(location))")
            if coordinate.distanceFromLocation(location) < closestCoordinate.distanceFromLocation(location) {
                closestCoordinate = coordinate
            }
        }
        let sortedArray = [dictionary.keys.first! : closestCoordinate]
        return sortedArray
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
//    func makeCoordinatesIntoArray(places: [[String : AnyObject]]) -> [[String : AnyObject]] {
//        var placesCopy = places
//        for place in places {
//            var coordinatesCopy = place["coordinates"]!.stringByReplacingOccurrencesOfString("(", withString: "")
//            coordinatesCopy = coordinatesCopy.stringByReplacingOccurrencesOfString(")", withString: "")
//            coordinatesCopy = coordinatesCopy.stringByReplacingOccurrencesOfString("MULTIPOLYGON", withString: "")
//            var locationArray = coordinatesCopy.componentsSeparatedByString(", ")
//            var coordinateArray: [CLLocation] = []
//            
//            for locationSubset in locationArray {
//                if locationSubset == locationArray[0] {
//                    var locationCoordinatesAsString = locationSubset.componentsSeparatedByString(" ")
//                    let locationCoordinates = CLLocation.init(latitude: ((locationCoordinatesAsString[2] as NSString).doubleValue), longitude: ((locationCoordinatesAsString[1] as NSString).doubleValue))
//                    coordinateArray.append(locationCoordinates)
//                    //                print("\(locationCoordinates.coordinate.latitude), \(locationCoordinates.coordinate.longitude)")
//                    
//                } else {
//                    var locationCoordinatesAsString = locationSubset.componentsSeparatedByString(" ")
//                    let locationCoordinates = CLLocation.init(latitude: ((locationCoordinatesAsString[1] as NSString).doubleValue), longitude: ((locationCoordinatesAsString[0] as NSString).doubleValue))
//                    coordinateArray.append(locationCoordinates)
//                    
//                }
//                
//            }
//            var placeCopy = place
//            placeCopy.updateValue(coordinateArray, forKey: "coordinates")
//            placesCopy.append(placeCopy)
//        }
////        let coordinateDictionary : [ String : Array<CLLocation>] = [coordinates.keys.first! : coordinateArray]
//        return placesCopy
//    }
    public func makeCoordinatesIntoArray(parks: String) -> Array<CLLocation> {
        print("called")
        //        var parkCopy : [[String : AnyObject]] = [[:]]
        //        for array in parks {
        //            var arrayCopy : [ String : AnyObject ] = array
        var coordinatesCopy = parks.stringByReplacingOccurrencesOfString("(", withString: "")
        coordinatesCopy = coordinatesCopy.stringByReplacingOccurrencesOfString(")", withString: "")
        coordinatesCopy = coordinatesCopy.stringByReplacingOccurrencesOfString("MULTIPOLYGON", withString: "")
        var locationArray = coordinatesCopy.componentsSeparatedByString(", ")
        var coordinateArray: [CLLocation] = []
        
        for locationSubset in locationArray {
            if locationSubset == locationArray[0] {
                var locationCoordinatesAsString = locationSubset.componentsSeparatedByString(" ")
                let locationCoordinates = CLLocation.init(latitude: ((locationCoordinatesAsString[2] as NSString).doubleValue), longitude: ((locationCoordinatesAsString[1] as NSString).doubleValue))
                coordinateArray.append(locationCoordinates)
                //                print("\(locationCoordinates.coordinate.latitude), \(locationCoordinates.coordinate.longitude)")
                
            } else {
                var locationCoordinatesAsString = locationSubset.componentsSeparatedByString(" ")
                let locationCoordinates = CLLocation.init(latitude: ((locationCoordinatesAsString[1] as NSString).doubleValue), longitude: ((locationCoordinatesAsString[0] as NSString).doubleValue))
                coordinateArray.append(locationCoordinates)
            }
        }
        //            parkCopy.append(arrayCopy)
        //
        //            arrayCopy.updateValue(coordinateArray, forKey: "coordinates")
        //        }
        //        print("parkCopy")
       let parksCopy = coordinateArray
        print("Done")
        
        return parksCopy
    }
}


