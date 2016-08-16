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
    let dataStore = DataStore()
    
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    var queue = NSOperationQueue()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //
        //        self.blurEffect.layer.cornerRadius = 50
        //
        //        self.blurEffect.clipsToBounds = true
        
        let blur = UIVisualEffectView(effect: UIBlurEffect(style:
            UIBlurEffectStyle.Light))
        blur.frame = CGRectMake(200, 200, 100, 100)
        
        blur.layer.cornerRadius = 10
        
        blur.layer.masksToBounds = true
        self.view.addSubview(blur)
        
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
                self.getOutdoorWifiSpots()
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
    
    func sortArrayByDistance(array : [[String : AnyObject]]) -> [[String : AnyObject]] {
        var arrayCopy : [[String:AnyObject]] = []
        let sortByDistance = NSSortDescriptor(key: "Distance", ascending: true)
        var tableViewArray : NSArray = array
        tableViewArray = tableViewArray.sortedArrayUsingDescriptors([sortByDistance])
//        print("Table view array: \(tableViewArray)")
        arrayCopy = tableViewArray as! [[String: AnyObject]]
//        print("ArrayCopy: \(arrayCopy)")
        return arrayCopy
    }
    
    // Parks
    func getParks() {
        print("Get parks")
        
        dataStore.populateParkByTypeBasedOnState("type", type: "Garden") {
            
//            print(self.dataStore.parkTypeArray)
            self.dataStore.parkTypeArray = self.sortArrayByDistance(self.dataStore.parkTypeArray)
            for park in self.dataStore.parkTypeArray {
                
                //                if self.isLessThan5MilesAway(park) {
                
                self.arrayOfParks.append(park["name"] as! String)
            }
        }
    }
    // Farmers' Market
    
    // Tweaked to get hours and season of operation
    func getFarmersMarkets() {
        
        dataStore.farmersMarketParse { completion in
            if completion {
                self.dataStore.farmersMarketArray = self.sortArrayByDistance(self.dataStore.farmersMarketArray)
                for marketDictionary in self.dataStore.farmersMarketArray {
                    
                    //                    if self.isLessThan5MilesAway(marketDictionary) {
                    
                    if let marketName = marketDictionary["name"] {
                        self.arrayOfFarmersMarkets.append(marketName as! String)
                    }
                }
            } else {
                print("ERROR: Unable to retrieve farmer's markets")
                
            }
//            print("FarmersMarketsArray : \(self.dataStore.farmersMarketArray)")
        }
        print("FarmersMarketsArray : \(self.dataStore.farmersMarketArray)")
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
//                            print(tempDictionary)
                            self.outdoorWifiSpots.append(tempDictionary)
                        }
                    }
                }
            }
//            print(self.outdoorWifiSpots)
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
            
//            dataStore.currentLocation = (locations.first)!
            
            locationManager.stopUpdatingLocation()
            
            //            print("You are here : \(dataStore.currentLocation)")
            
        }
        
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
}