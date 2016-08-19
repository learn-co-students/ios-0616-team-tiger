//
//  CommunityGardensTableViewController.swift
//  Team-Tiger
//
//  Created by Laticia Chance on 8/11/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CommunityGardensTableViewController: UITableViewController {

    var greenThumbdictionary = [:]
    var arrayOfGardens: [String] = []
    var greenThumbArray: [[String:String]] = []
    var arrayOfGardenAddresses: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        greenThumbParse { completion in
//            
//            if completion {
//                for gardenDictionary in self.greenThumbArray {
//                    if let gardenName = gardenDictionary["Garden"] {
//                        self.arrayOfGardens.append(gardenName)
//                    }
//                    
//                    if let gardenAddress = gardenDictionary["Address"] {
//                        self.arrayOfGardenAddresses.append(gardenAddress)
//                    }
//                }
//                NSOperationQueue.mainQueue().addOperationWithBlock({
//                    self.tableView.reloadData()
//                })
//            } else {
//                print("ERROR: Unable to retrieve community garden")
//            }
//        }
        
    }
    
//    func greenThumbParse(completionHandler: (Bool) -> ()) {
//        
//        // var greenThumbArray: [[String: String]] = []
//        
//        Alamofire.request(.GET, "https://data.cityofnewyork.us/api/views/3ckp-upxf/rows.json?accessType=DOWNLOAD") .responseJSON { response in
//            
//            self.greenThumbdictionary = response.result.value as! NSDictionary
//            
//            if let jsonData = response.data {
//                let jsonObj = JSON(data: jsonData)
//                
//                let arrayOfData = jsonObj["data"].array
//                
//                var dictionaryWithInfo = [String:String]()
//                
//                if let arrayOfData = arrayOfData {
//                    
//                    for detail in arrayOfData {
//                        
//                        dictionaryWithInfo["Garden"] = detail[12].string
//                        dictionaryWithInfo["Address"] = detail[13].string
//                        //dictionaryWithInfo["Cross Streets"] = detail[17].string
//                        dictionaryWithInfo["coordinates"] = detail[8].string
//                        dictionaryWithInfo["phone number"] = 
//                        if let neighborhoodInDictionary = detail[16].string {
//                            
//                            dictionaryWithInfo["neighborhood"] = neighborhoodInDictionary
//                            
//                        } else {
//                            print("\n\n\n NEIGHBORHOOD ISN'T PROVIDED\n\n\n")
//                        }
//                        
//                        self.greenThumbArray.append(dictionaryWithInfo)
//                    }
//                    completionHandler(true)
//                    
//                }
//                
//            }
//        }
//    }
//    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return arrayOfGardens.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = arrayOfGardens[indexPath.row]
        
        return cell
    }


}
