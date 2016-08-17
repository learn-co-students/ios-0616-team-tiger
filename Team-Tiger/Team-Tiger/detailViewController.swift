//
//  detailViewController.swift
//  Team-Tiger
//
//  Created by Ehsan Zaman on 8/14/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import UIKit
import CoreData


class detailViewController: UIViewController {
    
    
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationAddress: UILabel!
    @IBOutlet weak var locationType: UILabel!
    @IBOutlet weak var zipCode: UILabel!
    
    var locationToPresent: [String : AnyObject] = [:]
    
    let dataStore = DataStore.store
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(red: 125.0/255, green: 181.0/255, blue: 107.0/255, alpha: 100.0)
        
        
        // self.locationName.text = locationNameText
        var type = locationToPresent["type"] as! String
        locationName.text =  locationToPresent["name"] as! String
        locationAddress.text =  locationToPresent["address"] as! String
        
        //to replace after kens icons populate tableview
        if type.containsString("Garden") {
            type = type + " 🌿"
        }
        locationType.text = type
        zipCode.text =  locationToPresent["zip"] as! String
        
        print("Addresses of parks: \(locationAddress.text)")
        print(locationToPresent)
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func phoneNumber(sender: AnyObject) {
        var url: NSURL = NSURL(string: "tel://3472321892")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func saveToFavoritesTapped(sender: AnyObject) {
        
        
        let newFavorite = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: dataStore.managedObjectContext) as! Location
        
        newFavorite.name = (locationToPresent["name"] as! String)
        newFavorite.address = (locationToPresent["address"] as! String)
        
        if let type = locationToPresent["type"] {
            newFavorite.type = (type as! String)
        }
        
        if let zip = locationToPresent["zip"] {
            newFavorite.zip = (zip as! String)
        }
        
        if let waterfront = locationToPresent["waterfront"] {
            newFavorite.waterfront = (waterfront as! String)
        }
        
        if let hours = locationToPresent["hours"] {
            newFavorite.hours = (hours as! String)
        }
        
        newFavorite.user = dataStore.user[0]
        
        //dataStore.user[0].favorites?.setByAddingObject(newFavorite)
        
        dataStore.saveContext()
        dataStore.fetchData()
        
        
        print(dataStore.user[0].favorites?.count)
        
        
    }
    
    
    
}
