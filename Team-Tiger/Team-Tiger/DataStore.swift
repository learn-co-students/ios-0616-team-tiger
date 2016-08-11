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

class DataStore {
    
    var masterParksDictionary = [String : [String : String]]()
    
    
    
    //static makes it a singleton
    static let store = DataStore()
    var user = [User]()
    
    func fetchData() {
        
        let userFetchRequest = NSFetchRequest(entityName: "User")
        //execute fetch request
        //storing fetch request
        
        do {
            user = try managedObjectContext.executeFetchRequest(userFetchRequest) as! [User]
        } catch {
            print("ERROR")
        }
    }
    
    func generateData() {
        
        //possible that we may have to change this from let to var
        let firstUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: managedObjectContext) as! User
        
        saveContext()
        fetchData()
        
    }
    
    //Gets all park data at startup
    
    func getParks(completion: () -> ()) {
        
        var locationDictionary = [:]
        
        
        Alamofire.request(.GET, "https://data.cityofnewyork.us/api/views/p7jc-c8ak/rows.json?accessType=DOWNLOAD").responseJSON { (response) in
            locationDictionary = response.result.value as! NSDictionary
            
            
            let locationArrays = locationDictionary["data"] as! NSArray
            
            for location in locationArrays {
                
                var tempDictionary = [String : String]()
                
                tempDictionary["address"] = location[10] as? String
                tempDictionary["name"] = location[17] as? String
                tempDictionary["type"] = location[18] as? String
                tempDictionary["waterfront"] = location[19] as? String
                tempDictionary["zip"] = location[13] as? String
                tempDictionary["coordinates"] = location[8] as? String
                
                self.masterParksDictionary[(location[17] as? String)!] = tempDictionary as Dictionary
                
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
            
            
            let locationArrays = locationDictionary["data"] as! NSArray
            
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
    
}


