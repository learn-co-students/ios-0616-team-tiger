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
    
    var locationDictionary = [:]
    var parsedDictionary = [String : [String : String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        Alamofire.request(.GET, "https://data.cityofnewyork.us/api/views/p7jc-c8ak/rows.json?accessType=DOWNLOAD").responseJSON { (response) in
            self.locationDictionary = response.result.value as! NSDictionary
            
            
            
//            print(self.locationDictionary["data"]![0][10])
//            print(self.locationDictionary["data"]![0][13])
//            print(self.locationDictionary["data"]![0][17])
//            print(self.locationDictionary["data"]![0][18])
//            print(self.locationDictionary["data"]![0][19])
//            print(self.locationDictionary["data"]![0][8])
//            
//            print(self.locationDictionary["data"]![1][10])
//            print(self.locationDictionary["data"]![1][13])
//            print(self.locationDictionary["data"]![1][17])
//            print(self.locationDictionary["data"]![1][18])
//            print(self.locationDictionary["data"]![1][19])
//            print(self.locationDictionary["data"]![1][8])
//            
//            
//            print(self.locationDictionary)
            
            
            let locationArrays = self.locationDictionary["data"] as! NSArray
            
            for location in locationArrays {
                
                var tempDictionary = [String : String]()
                
                
                tempDictionary["address"] = location[10] as? String
                tempDictionary["name"] = location[17] as? String
                tempDictionary["type"] = location[18] as? String
                tempDictionary["waterfront"] = location[19] as? String
                tempDictionary["zip"] = location[13] as? String
                tempDictionary["coordinates"] = location[8] as? String
                
                self.parsedDictionary[(location[17] as? String)!] = tempDictionary
                
//                print("done")
                
            }
            
            print(self.parsedDictionary["TLC Sculpture Park Garden"]!["address"])
            
            


        }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

