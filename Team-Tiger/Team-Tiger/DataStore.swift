//
//  DataStore.swift
//  Team-Tiger
//
//  Created by Laticia Chance on 8/5/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import SwiftyJSON
import CoreLocation

class DataStore {
    
    var farmersMarketDictionaryArray = []
    var farmersMarketArray : [[String:AnyObject]] = []
    var parkTypeArray: [[String:AnyObject]] = []
    var gardenArray : [[String:AnyObject]] = []
    var masterParksDictionary = [String : [String : String]]()
    var currentLocation = CLLocation()
    var arrayOfParks: [String] = []
    
    
    //static makes it a singleton
    static let store = DataStore()
    
    var user = [User]()
    
    //
    //    func getJohannData(completion:()->()){
    //        ParksApiClient.getJohann { (userArray) in
    //            self.dataStoreUserArray = userArray
    //        }
    //    }
    
     
    func fetchData() {
        
        
        let userFetchRequest = NSFetchRequest(entityName: "User")
        
        do {
            user = try managedObjectContext.executeFetchRequest(userFetchRequest) as! [User]
        } catch {
            print("ERROR")
        }
        
        if user.count == 0 {
            
            generateData()
            
        }
    }
    
    func generateData() {
        
        //possible that we may have to change this from let to var
        let firstUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: managedObjectContext) as! User
        
        firstUser.favorites = []
        
        saveContext()
        fetchData()
        
    }
    
    func sortArrayByDistance(array : [[String : AnyObject]]) -> [[String : AnyObject]] {
        var arrayCopy : [[String:AnyObject]] = []
        let sortByDistance = NSSortDescriptor(key: "Distance", ascending: true)
        var tableViewArray : NSArray = array
        tableViewArray = tableViewArray.sortedArrayUsingDescriptors([sortByDistance])
        
        arrayCopy = tableViewArray as! [[String: AnyObject]]
        return arrayCopy
    }
    
    func farmersMarketParse(completionHandler: (Bool) -> ()) {
        Alamofire.request(.GET, "https://data.ny.gov/resource/farmersmarkets.json?") .responseJSON { response in
            
            if let response = response.result.value {
                self.farmersMarketDictionaryArray = response as! NSArray
                print("parsing")
                
            } else {
                print("received no response result from farmer's market")
            }
            
            if let jsonData = response.data {
                
                let jsonObj = JSON(data: jsonData)
                let arrayOfData = jsonObj.array
                self.farmersMarketArray.removeAll()
                if let arrayOfData = arrayOfData {
                    var dictionaryWithInfo : [String:AnyObject] = [:]
                    for detail in arrayOfData {
                        
                        dictionaryWithInfo.removeAll()
                        
                        if detail["county"] == "Kings" || detail["county"] == "Queens" || detail["county"] == "New York" || detail["county"] == "Bronx" || detail["county"] == "Richmond" {
                            dictionaryWithInfo["name"] = detail["market_name"].string
                            dictionaryWithInfo["zip"] = detail["zip"].string
                            dictionaryWithInfo["hours"] = detail["operation_hours"].string
                            dictionaryWithInfo["season"] = detail["operation_season"].string
                            dictionaryWithInfo["phone"] = detail["phone"].string
                            
                            if let latitude = detail["location_points"]["latitude"].string {
                                dictionaryWithInfo["latitude"] = Double(latitude)
                            }
                            
                            if let longitude = detail["location_points"]["longitude"].string {
                                dictionaryWithInfo["longitude"] = Double(longitude)
                            }
                            
                            if let addressInDictionary = detail["address_line_1"].string {
                                dictionaryWithInfo["address"] = addressInDictionary
                            } else {
                                
                                print("IN SEARCH OF ADDRESS")
                            }
                            
                            dictionaryWithInfo["coordinates"] = CLLocation(latitude: (dictionaryWithInfo["latitude"] as? Double)!, longitude: (dictionaryWithInfo["longitude"] as? Double)!)
                            
                            self.farmersMarketArray.append(dictionaryWithInfo)
                        }
                    }
                }
                print(self.currentLocation)
                print("Count: \(self.farmersMarketArray.count)")
//                print("Array: \(self.farmersMarketArray)")
                //                 self.farmersMarketArray = self.sortArrayByDistance(self.farmersMarketArray)
                
                //                print( self.farmersMarketArray)
                
                completionHandler(true)
                
            }
        }
    }
    
    //Gets all park data at startup
    
    func getParks(completion: () -> ()) {
        
        var locationDictionary = [:]
        Alamofire.request(.GET, "https://data.cityofnewyork.us/api/views/p7jc-c8ak/rows.json?accessType=DOWNLOAD").responseJSON { (response) in
            locationDictionary = response.result.value as! NSDictionary
            let locationArrays = locationDictionary["data"] as! Array<Array<AnyObject>>
//            print("LocationArrays : \(locationArrays)")
            for location in locationArrays {
                
                var tempDictionary = [String : String]()
                
                tempDictionary["address"] = location[10] as? String
                tempDictionary["name"] = location[17] as? String
                tempDictionary["type"] = location[18] as? String
                tempDictionary["waterfront"] = location[19] as? String
                tempDictionary["zip"] = location[13] as? String
                tempDictionary["coordinates"] = location[8] as? String
                
                self.masterParksDictionary[(location[17] as? String)!] = tempDictionary as? Dictionary
                
            }
            
            
            completion()
       }
    }
    
    //Used to call parks data on demand that is passed to getParkByTypeOnDemand method
    
    func getParksOnDemand(completion:(parks: [String : [String : String]]) -> ()) -> () {
        
        var parsedParksDictionary = [String : [String : String]]()
        
        var locationDictionary = [:]
        
        Alamofire.request(.GET, "https://data.cityofnewyork.us/api/views/p7jc-c8ak/rows.json?accessType=DOWNLOAD").responseJSON { (response) in
            locationDictionary = response.result.value as! NSDictionary
            
            
            let locationArrays = locationDictionary["data"] as! Array<Array<AnyObject>>
//            print("LocationArrays : \(locationArrays)")
            for location in locationArrays {
                
                var tempDictionary = [String : String]()
                
                tempDictionary["address"] = location[10] as? String
                tempDictionary["name"] = location[17] as? String
                tempDictionary["type"] = location[18] as? String
                tempDictionary["waterfront"] = location[19] as? String
                tempDictionary["zip"] = location[13] as? String
                tempDictionary["coordinates"] = location[8] as? String
                
                parsedParksDictionary[(location[17] as? String)!] = tempDictionary as Dictionary
                
            }
            completion(parks: parsedParksDictionary)
        }
        
    }
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.kencooke.Team_Tiger" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        
        let modelURL = NSBundle.mainBundle().URLForResource("Team_Tiger", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Team_Tiger.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
        
    }
    
    func getParkByType(category: String, type: String) {
        
        self.parkTypeArray.removeAll()
        
        let keys = Array(self.masterParksDictionary.keys)
        
        for key in keys {
            
            if self.masterParksDictionary[key]![category]!.containsString(type) == true {
                
                self.parkTypeArray.append(self.masterParksDictionary[key]!)
                
            }
            
        }
        self.parkTypeArray = self.organizeParkCoordinates(self.parkTypeArray)
//        print("ParkTypeArray = \(self.parkTypeArray)")
    }
    
    //To be used only when masterParkDictionary is empty. Otherwise, use getParkByType
    func getParkByTypeOnDemand(category: String, type: String, completion:() -> ()) {
        
        self.getParksOnDemand { (parks) in
            
            self.parkTypeArray.removeAll()
            
            let keys = Array(parks.keys)
            
            for key in keys {
                
                if parks[key]![category]?.containsString(type) == true{
                    
                    self.parkTypeArray.append(parks[key]!)
                }
            }
            
            self.parkTypeArray = self.organizeParkCoordinates(self.parkTypeArray)
//            print("ParkTypeArray = \(self.parkTypeArray)")
            
        }
        completion()
    }
    // Makes Coordinates Readable.
    func organizeParkCoordinates(parks : [[String : AnyObject]]) -> [[String : AnyObject]] {
        var parksCopy = [[String : AnyObject]]()
        
        for park in parks {
            var parkCopy : [String : AnyObject] = park
            
            if let coordinatesAsString = park["coordinates"] {
                
                parkCopy.updateValue(LocationStuff().makeCoordinatesIntoArray(coordinatesAsString), forKey: "coordinates")
                
                parkCopy = LocationStuff().sortWithDistance(parkCopy, location: self.currentLocation)
//                print("Used locationManager  ")
                
                parksCopy.append(parkCopy)
            }
        }
        
        return parksCopy
    }
    
    //Combines the custom "get" functions and picks one based on the existence on data in the masterParksDictionary
    func populateParkByTypeBasedOnState(category: String, type: String, completion:() -> ()) {
        
        if self.masterParksDictionary.count != 0 {
            
            getParkByType(category, type: type)
            
//            print("Results results results\(self.parkTypeArray)")
//            
            //
            //            print("Data existed in masterParksDictionary")
            completion()
            
        } else {
            
            getParkByTypeOnDemand(category, type: type, completion: {
                
                //                print("Results on demand \(self.typeResults)")
                
                print("Data retrieved on demand")
                
                completion()
            })
        }
    }
}

