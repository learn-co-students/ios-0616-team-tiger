//
//  ViewController.swift
//  Team-Tiger
//
//  Created by Kenneth Cooke on 8/4/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let dataStore = DataStore.store
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
  // Example use of ParksApiClient
        
//        let apiClient = ParksApiClient()
//        
//        apiClient.populateParkByTypeBasedOnState("type", type: "Garden") {
//            
//            print(apiClient.typeResults)
//        
//        }
//        var gardensCopy = [[String : AnyObject]]()
//        
//        for garden in gardens {
//            
//            
//            
//            var gardenCopy : [String : AnyObject] = garden
//            
//            if let coordinatesAsString = garden["coordinates"] {
//                
//                gardenCopy.updateValue(LocationStuff().makeCoordinatesIntoArray(coordinatesAsString), forKey: "coordinates")
//                
//                gardensCopy.append(gardenCopy)
//                
//                print(gardenCopy)
//                
//            }
//            
//        }

    
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

