//
//  ParksApiClient.swift
//  Team-Tiger
//
//  Created by Kenneth Cooke on 8/9/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import Foundation

class ParksApiClient {
    
    var typeResults = [[String : String]]()
    
    let dataStore = DataStore.store
    
    //To be used if the masterParksDictionary is already populated
    func getParkByType(category: String, type: String) {
        
        self.typeResults.removeAll()
        
        let keys = Array(dataStore.masterParksDictionary.keys)
        
        for key in keys {
            
            if dataStore.masterParksDictionary[key]![category] == type {
                
                self.typeResults.append(dataStore.masterParksDictionary[key]!)
                
            }
            
        }
        
    }
    
    //To be used only when masterParkDictionary is empty. Otherwise, use getParkByType
    func getParkByTypeOnDemand(category: String, type: String, completion:() -> ()) {
        
        dataStore.getParksOnDemand { (parks) in
            
            self.typeResults.removeAll()
            
            let keys = Array(parks.keys)
            
            for key in keys {
                
                if parks[key]![category] == type {
                    
                    self.typeResults.append(parks[key]!)
                    
                }
                
            }
            
            completion()
        }
        
    }
    
    func organizeParkCoordinates(parks : [[String : String]]) -> [[String : AnyObject]] {
        var parksCopy = [[String : AnyObject]]()
        
        for park in parks {
          
            var parkCopy : [String : AnyObject] = park
            
            if let coordinatesAsString = park["coordinates"] {
                
                parkCopy.updateValue(LocationStuff().makeCoordinatesIntoArray(coordinatesAsString), forKey: "coordinates")
                
                parksCopy.append(parkCopy)
                
                print(parkCopy)
                
            }
            
        }
        return parksCopy
    }
    
    //Combines the custom "get" functions and picks one based on the existence on data in the masterParksDictionary
    func populateParkByTypeBasedOnState(category: String, type: String, completion:() -> ()) {
        
        if dataStore.masterParksDictionary.count != 0 {
            
            getParkByType(category, type: type)
            
            print(self.typeResults)
            
            print("Data existed in masterParksDictionary")
            
        } else {
            
            getParkByTypeOnDemand(category, type: type, completion: {
                
                print(self.typeResults)
                
                print("Data retrieved on demand")
                
            })
        }
    }
    
    
    
}
