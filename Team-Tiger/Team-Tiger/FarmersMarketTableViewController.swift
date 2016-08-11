//
//  FarmersMarketTableViewController.swift
//  Team-Tiger
//
//  Created by Laticia Chance on 8/11/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FarmersMarketTableViewController: UITableViewController {
    
    var FMdictionary = [:]
    var dictionaryWithInfo = [String:String]()
    var farmersMarketArray: [[String:String]] = []
    var arrayOfNames: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        fmParse { completion in
            
            if completion {
                for marketDictionary in self.farmersMarketArray {
                    if let marketName = marketDictionary["name"] {
                        self.arrayOfNames.append(marketName)
                    }
                }
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.tableView.reloadData()
                })
            } else {
                print("ERROR: Unable to retrieve farmer's markets")
            }
            
        }
    }
    
    func fmParse(completionHandler: (Bool) -> ()) {
        
        
        Alamofire.request(.GET, "https://data.cityofnewyork.us/api/views/j8gx-kc43/rows.json?") .responseJSON { response in
            self.FMdictionary = response.result.value as! NSDictionary
            
            if let jsonData = response.data {
                let jsonObj = JSON(data: jsonData)
                
                let arrayOfData = jsonObj["data"].array
                
                if let arrayOfData = arrayOfData {
                    
                    for detail in arrayOfData {
                        
                        self.dictionaryWithInfo["name"] = detail[8].string
                        self.dictionaryWithInfo["zip"] = detail[13].string
                        self.dictionaryWithInfo["longitude"] = detail[15].string
                        self.dictionaryWithInfo["latitude"] = detail[14].string
                        
                        if let addressInDictionary = detail[10].string {
                            
                            self.dictionaryWithInfo["address"] = addressInDictionary
                            
                        } else {
                            print("IN SEARCH OF ADDRESS")
                        }
                        
                        self.farmersMarketArray.append(self.dictionaryWithInfo)
                        
                    }
                    completionHandler(true)
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return arrayOfNames.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = arrayOfNames[indexPath.row]
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

