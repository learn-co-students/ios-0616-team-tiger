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
        
        let keys = Array(dataStore.parsedParksDictionary.keys)
        
        var gardens: [[String : AnyObject]] = []
        
        for key in keys {
            
            if dataStore.parsedParksDictionary[key]!["type"] == "garden" {
                
                gardens.append(dataStore.parsedParksDictionary[key]!)
                
            }
//            print(gardens)
            
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
      
//        var gardens: [[String : String]] = []
//        
//        for location in (dataStore.parsedParksDictionary as Dictionary) {

  // Example use of ParksApiClient
        
//        let apiClient = ParksApiClient()
//        
//        apiClient.populateParkByTypeBasedOnState("waterfront", type: "Yes") {

//            
//            print(apiClient.typeResults)
        
//        }

        //// Changes coordinates to CLLocation for selected type
        
        //        print("Gardens \(gardens)")
//        var gardensCopy = [[String : AnyObject]]()
//        for garden in gardens {
//            
//            var gardenCopy : [String : AnyObject] = garden
//            if let coordinatesAsString = garden["coordinates"] {
//                gardenCopy.updateValue(LocationStuff().makeCoordinatesIntoArray(coordinatesAsString), forKey: "coordinates")
//                gardensCopy.append(gardenCopy)
//                print(gardenCopy)
//            }
//        }
//    
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

