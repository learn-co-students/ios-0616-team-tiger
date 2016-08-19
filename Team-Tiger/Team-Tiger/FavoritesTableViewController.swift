//
//  FavoritesTableViewController.swift
//  Team-Tiger
//
//  Created by Kenneth Cooke on 8/17/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController {
    
    let dataStore = DataStore.store
    var favorites:[Location] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        dataStore.fetchData()
        
        for favorite in dataStore.user[0].favorites! {
            
            self.favorites.append(favorite as! Location)
            
        }
        
        self.tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.favorites.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("basicCell", forIndexPath: indexPath)
        
        assignIconForCell(cell, indexPath: indexPath)
        
        if indexPath.row % 2 == 0 {
            
            cell.backgroundColor = UIColor.init(red: 161.0/255, green: 212.0/255, blue: 144.0/255, alpha: 100.0)
            
        } else {
            
            cell.backgroundColor = UIColor.init(red: 125.0/255, green: 181.0/255, blue: 107.0/255, alpha: 100.0)
            
        }
        
        cell.textLabel?.text = self.favorites[indexPath.row].name
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func assignIconForCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        
        let favorite = self.favorites[indexPath.row]
        
        
        if let waterfrontValue = favorite.waterfront {
            
            
            if favorite.name!.lowercaseString.containsString("market") || favorite.name!.lowercaseString.containsString("stand") {
                
                cell.imageView?.image = UIImage.init(named: "tinyShop")
                
                
            } else if waterfrontValue == "Yes" {
                
                cell.imageView?.image = UIImage.init(named: "tinyWaterfront")
                
            } else if favorite.name!.lowercaseString.containsString("garden") {
                
                cell.imageView?.image = UIImage.init(named: "tinyFlower")
                
                
            }
            
        }
        
    }
    
    
}
