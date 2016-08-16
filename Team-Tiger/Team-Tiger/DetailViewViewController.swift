//
//  DetailViewViewController.swift
//  Team-Tiger
//
//  Created by Kenneth Cooke on 8/12/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import Foundation
import UIKit

class DetailViewViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let client = ParksApiClient()
        
        client.populateParkByTypeBasedOnState("type", type: "Garden") { 
            let ourOneDictionary = client.typeResults[0]
            
            let name = ourOneDictionary["name"]
            let waterfront = ourOneDictionary["waterfront"]
            
            
            print("\(name) \(waterfront)")
            
        }
        
        
        
    }
}