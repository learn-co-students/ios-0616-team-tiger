////
////  ParksApiClient.swift
////  Team-Tiger
////
////  Created by Kenneth Cooke on 8/9/16.
////  Copyright © 2016 kencooke. All rights reserved.
////
//
//import Foundation
//import MapKit
//import Alamofire
//import SwiftyJSON
//
//class ParksApiClient {
//    
//    var typeResults = [[String : AnyObject]]()
//    //You don't actually need access to the datastore 
//    
//    let dataStore = DataStore.store
//    
////    class func getJohann(completion:([User])->()){
////        var userArray = [User]()
////        //do some kind of api call which must give you back array 
////        Alamofire.request(.GET, "www.example.com").responseJSON { (response) in
////            let jsonData = JSON(data: response.data!)
////            //do some stuff to get an array 
////            var jsonArray = jsonData["cats"].array!
////            for json in jsonArray{
////                //create a user
////                //add each user to userArray
////            }
////            completion(userArray)
////        }
////    }
//    
//    //To be used if the masterParksDictionary is already populated
//    func getParkByType(category: String, type: String) {
//        
//        self.typeResults.removeAll()
//        
//        let keys = Array(dataStore.masterParksDictionary.keys)
//        
//        for key in keys {
//            
//            if dataStore.masterParksDictionary[key]![category] == type {
//                
//                self.typeResults.append(dataStore.masterParksDictionary[key]!)
//                
//            }
//            
//        }
//        self.typeResults = self.organizeParkCoordinates(self.typeResults)
//    }
//    
//    //To be used only when masterParkDictionary is empty. Otherwise, use getParkByType
//    func getParkByTypeOnDemand(category: String, type: String, completion:() -> ()) {
//        
//        dataStore.getParksOnDemand { (parks) in
//            
//            self.typeResults.removeAll()
//            
//            let keys = Array(parks.keys)
//            
//            for key in keys {
//                
//                if parks[key]![category] == type {
//                    
//                    self.typeResults.append(parks[key]!)
//                    // Changes the coordinates to coordinates
//                    
//                }
//                
//            }
//            self.typeResults = self.organizeParkCoordinates(self.typeResults)
//            
//            
//            completion()
//        }
//        
//    }
//    
//    func organizeParkCoordinates(parks : [[String : AnyObject]]) -> [[String : AnyObject]] {
//        var parksCopy = [[String : AnyObject]]()
//        
//        for park in parks {
//            var parkCopy : [String : AnyObject] = park
//            
//            if let coordinatesAsString = park["coordinates"] {
//                
//                parkCopy.updateValue(LocationStuff().makeCoordinatesIntoArray(coordinatesAsString), forKey: "coordinates")
//                let testLocation = CLLocation(latitude: 40.75921100, longitude: -73.98463800)
////                testLocation.coordinate = CLLocationCoordinate2D(latitude: 40.75921100, longitude: -73.98463800)
//                if ButtonsViewController().locationManager.location == nil {
//                    parkCopy = LocationStuff().sortWithDistance(parkCopy, location: testLocation)
//                    print("Used testLocation")
//                } else {
//                parkCopy = LocationStuff().sortWithDistance(parkCopy, location: ButtonsViewController().locationManager.location!)
//                print("Used locationManager  ")
//                }
//                parksCopy.append(parkCopy)
//            }
//        }
//        
//        return parksCopy
//    }
//    
//    //Combines the custom "get" functions and picks one based on the existence on data in the masterParksDictionary
//    func populateParkByTypeBasedOnState(category: String, type: String, completion:() -> ()) {
//        
//        if self.typeResults.count != 0 {
//            
//            getParkByType(category, type: type)
//            
//            print("Results results results\(self.typeResults)")
////
////            print("Data existed in masterParksDictionary")
//            completion()
//        } else {
//            
//            getParkByTypeOnDemand(category, type: type, completion: {
//                
////                print("Results on demand \(self.typeResults)")
//                
//                print("Data retrieved on demand")
//             completion()
//            })
//        }
//    }
//    
//    
//    
//}
