//
//  ButtonsViewController.swift
//  Team-Tiger
//
//  Created by Kenneth Cooke on 8/12/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit
import CoreData

class ButtonsViewController: UIViewController, CLLocationManagerDelegate {
    
    var FMdictionary = [:]
    var dictionaryWithInfo = [String:String]()
    var farmersMarketArray: [[String:String]] = []
    var arrayOfFarmersMarkets: [String] = []
    var arrayOfParks: [String] = []
    let locationManager = CLLocationManager()
    
    let dataStore = DataStore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            print("Yay for location")
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
            
        } else {
            print("No go on location")
        }
        
        
        
    }
    override func viewDidAppear(animated: Bool) {
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
       let apiClient = ParksApiClient()
        
        apiClient.populateParkByTypeBasedOnState("type", type: "Garden") {
                        print(apiClient.typeResults)
            let sortByDistance = NSSortDescriptor(key: "Distance", ascending: true)
            var tableViewArray : NSArray = apiClient.typeResults
            tableViewArray = tableViewArray.sortedArrayUsingDescriptors([sortByDistance])
            apiClient.typeResults = tableViewArray as! [[String: AnyObject]]
            
//            self.arrayOfParks = apiClient.typeResults
            
            print("Maybe sorted \(apiClient.typeResults)")
            
            for park in apiClient.typeResults {
                
                self.arrayOfParks.append(park["name"] as! String)
                
                
            }
            
            print("Names \(self.arrayOfParks)")
            
        
        
        }
        
        
        fmParse { completion in
            
            if completion {
                for marketDictionary in self.farmersMarketArray {
                    if let marketName = marketDictionary["name"] {
                        self.arrayOfFarmersMarkets.append(marketName)
                    }
                }
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    // self.tableView.reloadData()
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
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     
     */
    
    
    @IBAction func shopTapped(sender: AnyObject) {
        
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        
        
        let destinationVC = segue.destinationViewController as! SearchResultsTableViewController
        
        //print("Passing: \(self.arrayOfParks)")
        
        if segue.identifier == "showParks" {
        
        destinationVC.arrayOfNames = self.arrayOfParks
            
        } else {
            
            destinationVC.arrayOfNames = self.arrayOfFarmersMarkets
            
        }
        
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("We know where you are")
        if locations.count > 0 {
            dataStore.currentLocation = (locations.first)!
            locationManager.stopUpdatingLocation()
            print("You are here : \(dataStore.currentLocation)")
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}

