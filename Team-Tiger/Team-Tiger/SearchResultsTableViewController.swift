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
    var valueToPass : [String: AnyObject] = [:]
    
    var tappedCell: Int = 0
    var newDictionary: [[String : AnyObject]] = []
    
    let dataStore = DataStore.store

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("PARKS IN ARRAY \(dataStore.parkTypeArray)")
      
        
        
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
        
        cell.textLabel?.text = arrayOfNames[indexPath.row]
    
        print(valueToPass)
    
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if segue.identifier == "showDetail" {
             let newVC = segue.destinationViewController as! detailViewController
            self.tappedCell = (tableView.indexPathForSelectedRow?.row)!
           
            newVC.dictionaryOfData = dataStore.parkTypeArray[tappedCell]

            
        }
        
    }
}
