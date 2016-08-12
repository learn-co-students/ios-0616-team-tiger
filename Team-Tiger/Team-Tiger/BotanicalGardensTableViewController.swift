//
//  BotanicalGardensTableViewController.swift
//  Team-Tiger
//
//  Created by Laticia Chance on 8/11/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BotanicalGardensTableViewController: UITableViewController {
    
    var botanicalGardenDict = [:]
    var arrayOfGardens: [String] = []
    var botanicalGardenArray: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        botanicalGardensParse { completion in
            
            if completion {
                for gardenDictionary in self.botanicalGardenArray {
                    if let gardenName = gardenDictionary["Botanical Garden"] {
                        self.arrayOfGardens.append(gardenName)
                    }
                }
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.tableView.reloadData()
                })
            } else {
                print("ERROR: Unable to retrieve community garden")
            }
        }
        
    }
    
    func botanicalGardensParse(completionHandler: (Bool) -> ()) {
        
        Alamofire.request(.GET, "https://data.cityofnewyork.us/api/views/69ih-b9ki/rows.json?accessType=DOWNLOAD") .responseJSON {
            response in
            
            self.botanicalGardenDict = response.result.value as! NSDictionary
            
            if let JSONdata = response.data {
                let jsonObject = JSON(data: JSONdata)
                
                let arrayofData = jsonObject["data"].array
                
                var botanicalGardenDictionary = [String:String]()
                 
                for object in arrayofData! {
                    
                    botanicalGardenDictionary["Botanical Garden"] = object[9].string
                    botanicalGardenDictionary["Phone Number"] = object[10].string
                    botanicalGardenDictionary["Website"] = object[11].string
                    botanicalGardenDictionary["Address"] = object[12].string
                    botanicalGardenDictionary["Borough"] = object[14].string
                    
                    self.botanicalGardenArray.append(botanicalGardenDictionary)
                    
                }
                completionHandler(true)
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.arrayOfGardens.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = arrayOfGardens[indexPath.row]
        
        return cell
    }
    
}