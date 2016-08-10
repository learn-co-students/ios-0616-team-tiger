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
        
        let gardensCopy = LocationStuff().makeCoordinatesIntoArray(gardens)
        print(gardens)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
      
//        var gardens: [[String : String]] = []
//        
//        for location in (dataStore.parsedParksDictionary as Dictionary) {
//            
//            let dictionary = Dictionary(dictionaryLiteral: location)
//            if location["type"] = "garden" {
//                
//            gardens.append(location)
//                
//                
//            }
        
//        }
        
        
    
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

