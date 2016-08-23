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
        cell.detailTextLabel?.textColor = UIColor.whiteColor()
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if segue.identifier == "showDetail" {
             let newVC = segue.destinationViewController as! detailViewController
            self.tappedCell = (tableView.indexPathForSelectedRow?.row)!

            newVC.locationToPresent = dataStore.parkTypeArray[tappedCell]
            
        }
        
    }
    
    func assignIconForCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        
        let currentLocation = dataStore.parkTypeArray[indexPath.row]
        
        let waterfrontValue = currentLocation["waterfront"] as! String
        
//        print(waterfrontValue)
        
        let currentMarketOrGarden = self.arrayOfNames[indexPath.row]
        
        if currentMarketOrGarden.lowercaseString.containsString("market") || currentMarketOrGarden.lowercaseString.containsString("stand") {
            
            cell.imageView?.image = UIImage.init(named: "tinyShop")
            
            
        } else if waterfrontValue == "Yes" {
            
            cell.imageView?.image = UIImage.init(named: "tinyWaterfront")
            
        } else if currentMarketOrGarden.lowercaseString.containsString("garden") {
            
            cell.imageView?.image = UIImage.init(named: "tinyFlower")
            
            
        }
        
    }
}
