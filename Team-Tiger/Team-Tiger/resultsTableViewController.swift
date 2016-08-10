//
//  resultsTableViewController.swift
//  Team-Tiger
//
//  Created by Ehsan Zaman on 8/10/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import UIKit
import Alamofire


class resultsTableViewController: UITableViewController {
       let dataStore = DataStore.store


     var arrayOfNames = [String]()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        dataStore.getParks { 
            
            let arrayOfNames2 = Array(self.dataStore.parsedParksDictionary.keys)
            self.arrayOfNames = arrayOfNames2
            print(self.arrayOfNames)
            self.tableView.reloadData()
            print("data loaded")
        }
    
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfNames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("basicCell", forIndexPath: indexPath)
        cell.textLabel?.text = arrayOfNames[indexPath.row]
        
        
        
        
                    return cell
                }
            }

