//
//  FarmersMarketTableViewController.swift
//  Team-Tiger
//
//  Created by Laticia Chance on 8/11/16.
//  Copyright © 2016 kencooke. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class FarmersMarketTableViewController: UITableViewController {
    
    var FMdictionary = [:]
    var dictionaryWithInfo = [String:String]()
    var farmersMarketArray: [[String:AnyObject]] = []
    var arrayOfNames: [String] = []
    var tableViewArray : NSArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        fmParse { completion in
            
            if completion {
                for marketDictionary in self.tableViewArray {
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
        self.arrayOfData = getCoordinatesFromAddress(self.arrayOfData)
        let sortByDistance = NSSortDescriptor(key: "Distance", ascending: true)
        self.tableViewArray  = self.arrayOfData
        self.tableViewArray = tableViewArray.sortedArrayUsingDescriptors([sortByDistance])
        print(tableViewArray)
        
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
    
    func getCoordinatesFromAddress(array : [[String : AnyObject]]) -> [[String : AnyObject]] {
        var arrayCopy = [[String : AnyObject]]()
        for dictionary in array {
            var dictionaryCopy = dictionary
            let address = "\(String(dictionary["address"]))"
            CLGeocoder().geocodeAddressString(address, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                if let placemark = placemarks?.first {
                    dictionaryCopy.updateValue((placemark.location)!, forKey: "coordinates")
                    dictionaryCopy.updateValue((placemark.location)!, forKey: "Closest Coordinate")
                    dictionaryCopy.updateValue((placemark.location?.distanceFromLocation(self.dataStore.currentLocation))!, forKey: "Distance")
                }
            })
            arrayCopy.append(dictionaryCopy)
        }
        return arrayCopy
    }
}

