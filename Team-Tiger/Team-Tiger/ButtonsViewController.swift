import UIKit
import Alamofire
import SwiftyJSON
import MapKit
import CoreData
import Foundation

class ButtonsViewController: UIViewController, CLLocationManagerDelegate {
    var FMdictionary = []
    var dictionaryWithInfo = [String:AnyObject]()
    var farmersMarketArray: [[String:AnyObject]] = []
    var arrayOfFarmersMarkets: [String] = []
    var arrayOfParks: [String] = []
    let locationManager = CLLocationManager()
    let dataStore = DataStore.store
    
    @IBOutlet weak var blurEffect: UIView!
    var queue = NSOperationQueue()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.blurEffect.layer.cornerRadius = 10
        
        self.blurEffect.clipsToBounds = true
        
        
        queue.addOperationWithBlock {
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.getLocation()
                
                print("Location located")
            }
            NSOperationQueue.mainQueue().addOperationWithBlock {
                
                self.getFarmersMarkets()
                print("Farmers markets")
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                
                self.getParks()
                print("All the parks")
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                
                //                self.getOutdoorWifiSpots()
                print("Wifi Found")
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                
                //                print("Count: \(self.outdoorWifiSpots.count)")
                
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isLessThan5MilesAway(array : [String: AnyObject]) ->Bool {
        
        return (array["Distance"] as? Double) < 5
    }
    // Parks
    func getParks() {
        print("Get parks")
        
        dataStore.populateParkByTypeBasedOnState("type", type: "Garden") {
            
            //print("PRINTING ARRAY FROM BUTTON VC\(self.dataStore.parkTypeArray)")
            
            let sortByDistance = NSSortDescriptor(key: "Distance", ascending: true)
            
            var tableViewArray : NSArray = self.dataStore.parkTypeArray
            
            tableViewArray = tableViewArray.sortedArrayUsingDescriptors([sortByDistance])
            
            self.dataStore.parkTypeArray = tableViewArray as! [[String: AnyObject]]
            for park in self.dataStore.parkTypeArray {
                
                //                if self.isLessThan5MilesAway(park) {
                
                self.arrayOfParks.append(park["name"] as! String)
                
                
                
            }
//            print("PRINTING AFTER SORT ARRAY FROM BUTTON VC\(self.dataStore.parkTypeArray)")
        }
        
    }
    // Farmers' Market
    
    // Tweaked to get hours and season of operation
    func getFarmersMarkets() {
        
        self.fmParse { completion in
            if completion {
                
                for marketDictionary in self.farmersMarketArray {
                    
                    //                    if self.isLessThan5MilesAway(marketDictionary) {
                    
                    if let marketName = marketDictionary["name"] {
                        self.arrayOfFarmersMarkets.append(marketName as! String)
                    }
                }
            } else {
                print("ERROR: Unable to retrieve farmer's markets")
                
            }
            
            //            self.getCoordinates()
            
            print(self.arrayOfFarmersMarkets)
        }
    }
    
    func sortMarkets(array : [[String : AnyObject]]) -> [[String : AnyObject]] {
        
        var arrayCopy : [[String : AnyObject]] = []
        let sortByDistance = NSSortDescriptor(key: "Distance", ascending: true)
        var tableViewArray : NSArray = array
        tableViewArray = tableViewArray.sortedArrayUsingDescriptors([sortByDistance])
        
        arrayCopy = tableViewArray as! [[String: AnyObject]]
        return arrayCopy
    }
    
    func fmParse(completionHandler: (Bool) -> ()) {
        Alamofire.request(.GET, "https://data.ny.gov/resource/farmersmarkets.json?") .responseJSON { response in
            
            if let response = response.result.value {
                
                self.FMdictionary = response as! NSArray
                
                print("parsing")
                
            } else {
                
                print("received no response result from farmer's market")
                
            }
            
            if let jsonData = response.data {
                
                let jsonObj = JSON(data: jsonData)
                let arrayOfData = jsonObj.array
                if let arrayOfData = arrayOfData {
                    
                    //                    print(arrayOfData)
                    
                    for detail in arrayOfData {
                        
                        self.dictionaryWithInfo.removeAll()
                        
                        if detail["county"] == "Kings" || detail["county"] == "Queens" || detail["county"] == "New York" || detail["county"] == "Bronx" || detail["county"] == "Richmond" {
                            self.dictionaryWithInfo["name"] = detail["market_name"].string
                            self.dictionaryWithInfo["zip"] = detail["zip"].string
                            self.dictionaryWithInfo["hours"] = detail["operation_hours"].string
                            self.dictionaryWithInfo["season"] = detail["operation_season"].string
                            
                            if let latitude = detail["location_points"]["latitude"].string {
                                
                                self.dictionaryWithInfo["latitude"] = Double(latitude)
                                
                            }
                            
                            if let longitude = detail["location_points"]["longitude"].string {
                                
                                self.dictionaryWithInfo["longitude"] = Double(longitude)
                                
                            }
                            
                            if let addressInDictionary = detail["address_line_1"].string {
                                
                                self.dictionaryWithInfo["address"] = addressInDictionary
                                
                                
                                
                            } else {
                                
                                print("IN SEARCH OF ADDRESS")
                            }
                            //
                            
                            if let location = self.locationManager.location {
                                
                                let coordinates = CLLocation(latitude: (self.dictionaryWithInfo["latitude"] as! Double), longitude: (self.dictionaryWithInfo["longitude"] as! Double))
                                
                                print(coordinates)
                                
                                let distance = coordinates.distanceFromLocation(location) * 0.00062137
                                self.dictionaryWithInfo.updateValue(distance, forKey: "Distance")
                            }
                            
                            self.farmersMarketArray.append(self.dictionaryWithInfo)
                            
                        }
                    }
                }
                
                print("Count: \(self.farmersMarketArray.count)")
                
                self.farmersMarketArray = self.sortMarkets(self.farmersMarketArray)
                
                print(self.farmersMarketArray)
                
                completionHandler(true)
                
            }
        }
    }
    
    // Wifi
    
    var linkNycWifiSpots : [[String : AnyObject]] = []
    
    var outdoorWifiSpots : [[String : AnyObject]] = []
    
    func getOutdoorWifiSpots()  {
        var locationArray = [[String : AnyObject]]()
        
        Alamofire.request(.GET, "https://data.cityofnewyork.us/resource/jd4g-ks2z.json") .responseJSON {
            
            response in
            
            locationArray = response.result.value as! Array
            
            print("parsing")
            
            if let jsonData = response.data {
                
                let jsonObj = JSON(data: jsonData)
                
                
                
                let arrayOfData = jsonObj.array
                
                
                
                if let arrayOfData = arrayOfData {
                    
                    
                    
                    for location in arrayOfData {
                        
                        
                        
                        if location["location_t"].string == ("Outdoor Kiosk") {
                            
                            var tempDictionary : [String : AnyObject] = [:]
                            
                            //                            print("Outdoor \(location["name"])")
                            
                            if location["name"] != nil {
                                
                                tempDictionary["name"] = location["name"].string
                                
                            }
                            
                            if location["location_t"] != nil {
                                
                                tempDictionary["location_t"] = location["location_t"].string
                                
                            }
                            
                            
                            
                            if location["lon"] != nil {
                                
                                tempDictionary["long"] = location["lon"].string
                                
                            }
                            
                            
                            
                            if location["ssid"] != nil {
                                
                                tempDictionary["ssid"] = location["ssid"].string
                                
                            }
                            
                            
                            
                            if location["zip"] != nil{
                                
                                tempDictionary["zip"] = location["zip"].string
                                
                            }
                            
                            
                            
                            if location["lat"] != nil {
                                
                                tempDictionary["lat"] = location["lat"].string
                                
                            }
                            
                            
                            
                            print(tempDictionary)
                            
                            self.outdoorWifiSpots.append(tempDictionary)
                            
                        }
                        
                    }
                    
                }
                
            }
            
            print(self.outdoorWifiSpots)
            
        }
        
    }
    @IBAction func shopTapped(sender: AnyObject) {
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destinationVC = segue.destinationViewController as! SearchResultsTableViewController
        
        if segue.identifier == "showParks" {
            
            destinationVC.arrayOfNames = self.arrayOfParks
            
        } else {
            
            destinationVC.arrayOfNames = self.arrayOfFarmersMarkets
            
        }
        
    }
    //Location Things
    
    func getLocation() {
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            print("Yay for location")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            
            locationManager.requestLocation()
            
            locationManager.startUpdatingLocation()
        } else {
            
            print("No go on location")
            
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("We know where you are")
        
        if locations.count > 0 {
            
            dataStore.currentLocation = (locations.first)!
            
            locationManager.stopUpdatingLocation()
            
            //            print("You are here : \(dataStore.currentLocation)")
            
        }
        
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
}