//
//  SearchResultsTableViewController.swift
//  Team-Tiger
//
//  Created by Kenneth Cooke on 8/12/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import UIKit


class SearchResultsTableViewController: UITableViewController {
    
    var arrayOfNames: [String] = []
    var arrayOfDistance : [String] = []
    
    var tappedCell: Int = 0
    
    let dataStore = DataStore.store
    
    var displayedDataType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //
        //        let getDetailsForMarkets = dataStore.getGoogleDetailsForCloseLocation(dataStore.locationsFromDataStore.farmersMarketArray[0], completionHandler: ([String:String]))
        //        let getDetailsForGardens = dataStore.getGoogleDetailsForCloseLocation(dataStore.locationsFromDataStore.greenThumbArray[0], completionHandler: ([String:String]))
        //        let getDetailsForParks = dataStore.getGoogleDetailsForCloseLocation(dataStore.parkTypeArray, completionHandler: ([String:String]))
        //
        self.tableView.reloadData()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return arrayOfNames.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("basicCell", forIndexPath: indexPath)
        
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        assignIconForCell(cell, indexPath: indexPath)
        
        
        if indexPath.row % 2 == 0 {
            
            cell.backgroundColor = UIColor.init(red: 161.0/255, green: 212.0/255, blue: 144.0/255, alpha: 100.0)
            
            
        } else {
            
            cell.backgroundColor = UIColor.init(red: 125.0/255, green: 181.0/255, blue: 107.0/255, alpha: 100.0)
            
        }
        
        
        cell.textLabel?.text = arrayOfNames[indexPath.row]
        
        cell.detailTextLabel?.text = arrayOfDistance[indexPath.row]
        
        return cell
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let newVC = segue.destinationViewController as! detailViewController
        
        self.tappedCell = (tableView.indexPathForSelectedRow?.row)!
        
        
        
        if self.displayedDataType == "parks" {
            
            newVC.locationToPresent = dataStore.parkTypeArray[tappedCell]
            
            newVC.passedDataType = "parks"
            
        } else if self.displayedDataType == "markets" {
            
            newVC.locationToPresent = dataStore.farmersMarketArray[tappedCell]
            
            newVC.passedDataType = "markets"
            
        } else {
            
            newVC.locationToPresent = dataStore.greenThumbArray[tappedCell]
            
            newVC.passedDataType = "gardens"
            
        }
        
        
        
    }
    
    func assignIconForCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        
        let currentLocation = dataStore.parkTypeArray[indexPath.row]
        
//        print(currentLocation["name"])
//        
//        print(indexPath.row)
        
        let waterfrontValue = currentLocation["waterfront"] as! String
        
        //        print(waterfrontValue)
        
//        let currentMarketOrGarden = self.arrayOfNames[indexPath.row]
        
        if self.displayedDataType == "markets" {
            
            cell.imageView?.image = UIImage.init(named: "tinyShop")
            
        }
        
            
        if self.displayedDataType == "parks" && waterfrontValue == "Yes" {
            
            cell.imageView?.image = UIImage.init(named: "tinyWaterfront")
            
        } else if self.displayedDataType == "parks" {
            
            cell.imageView?.image = UIImage.init(named: "tinySpa")
            
            
        }
        
//        if ((currentLocation["name"]?.lowercaseString.containsString("garden")) == true) {
//            
//            cell.imageView?.image = UIImage.init(named: "tinyFlower")
//            
//        }
        
        if self.displayedDataType == "gardens" {
            
            cell.imageView?.image = UIImage.init(named: "tinyFlower")
            
            
        }
        
    }
}
