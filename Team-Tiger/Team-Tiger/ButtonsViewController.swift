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
    
    var zip : String = ""
    
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    
    
    var queue = NSOperationQueue()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        self.blurEffect.layer.cornerRadius = 10
        
        
        self.blurEffect.clipsToBounds = true
        
        
        queue.addOperationWithBlock {
            NSOperationQueue.mainQueue().addOperationWithBlock {
                //                self.getLocation()
                self.dataStore.populateParkByTypeBasedOnState("type", type: "Park", completion: {
                    
                    //                                    self.dataStore.populateParkByTypeBasedOnState("type", type: "Community Park", completion: {
                    print(self.dataStore.parkTypeArray)
                })
                
            
            //            self.dataStore.populateParkByTypeBasedOnState("type", type: "Garden", completion: {
            //                print(self.dataStore.gardenArray)
            //            })
            
            //                print("Location located")
        }
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.getFarmersMarkets()
            
            print("Farmers markets")
            
            self.getParks({
                self.dataStore.parkTypeArray = self.sortArrayByDistance(self.dataStore.parkTypeArray)
                for park in self.dataStore.parkTypeArray {
                    self.arrayOfParks.append(park["name"] as! String)
                }
            })
            
            print("All the parks")
            
            self.getOutdoorWifiSpots()
            print("Wifi Found")
            //
        }
        //
        //            NSOperationQueue.mainQueue().addOperationWithBlock {
        //
        //
        //            }
        //
        //            NSOperationQueue.mainQueue().addOperationWithBlock {
        //                            }
        //
        //            NSOperationQueue.mainQueue().addOperationWithBlock {
        //
        //                //                print("Count: \(self.outdoorWifiSpots.count)")
        //
        //            }
    }
}

override func viewDidAppear(animated: Bool) {
}

override func viewWillAppear(animated: Bool) {
    //        self.getLocation()
    
}

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}

func isLessThan5MilesAway(array : [[String: AnyObject]]) -> [[String: AnyObject]] {
    let arrayCopy = array.filter({ ($0["Distance"] as! Double) < 5.0 })
    return arrayCopy
}

func sortArrayByDistance(array : [[String : AnyObject]]) -> [[String : AnyObject]] {
    let sortedByDistance = array.sort { ($0["Distance"] as! Double) < ($1["Distance"] as! Double) }
    print("Sortedsortedsorted \(sortedByDistance)")
    return sortedByDistance
}

// Parks
func getParks(completion: () -> ()) {
    print("Get parks")
    dataStore.populateParkByTypeBasedOnState("type", type: "Garden", completion: {
        print("Got gardens")
    })
    
    //        self.arrayOfParks = dataStore.parkTypeArray
}
// Farmers' Market

// Tweaked to get hours and season of operation
func getFarmersMarkets() {
    var farmersArrayCopy : [[String : AnyObject]] = []
    dataStore.farmersMarketParse { completion in
        if completion {
            
            for market in self.dataStore.farmersMarketArray {
                let location = self.dataStore.currentLocation
                let coordinates = CLLocation(latitude: (market["latitude"] as! Double), longitude: (market["longitude"] as! Double))
                let distance = (coordinates.distanceFromLocation(location) * 0.00062137)
                var marketCopy = market
                marketCopy.updateValue(distance, forKey: "Distance")
                farmersArrayCopy.append(marketCopy)
                
            }
            //            print("Copycopycopycopy : \(farmersArrayCopy)")
            self.dataStore.farmersMarketArray = self.sortArrayByDistance(farmersArrayCopy)
            //                self.dataStore.farmersMarketArray = self.isLessThan5MilesAway(self.dataStore.farmersMarketArray)
            for marketDictionary in self.dataStore.farmersMarketArray {
                
                if let marketName = marketDictionary["name"] {
                    self.arrayOfFarmersMarkets.append(marketName as! String)
                }
            }
        } else {
            print("ERROR: Unable to retrieve farmer's markets")
            
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
    }
}
@IBAction func shopTapped(sender: AnyObject) {
    
}
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let destinationVC = segue.destinationViewController as! SearchResultsTableViewController
    if segue.identifier == "showParks" {
        
        destinationVC.arrayOfNames = self.arrayOfParks
    } else if segue.identifier == "showParks" {
        
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
        self.getZipCode()
        
        print("No go on location")
    }
}

func locationManager(manager: CLLocationManager, startUpdatingLocation location: CLLocation) {
    dataStore.currentLocation = location
    print("Data Store Location : \(dataStore.currentLocation)")

}
func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if locations.count > 0 {
        dataStore.currentLocation = (locations.first)!
        self.locationManager.stopUpdatingLocation()
        
    }
}
func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    
    print("Failed to find user's location: \(error.localizedDescription)")
}


func getZipCode() {
    var alertController:UIAlertController?
    alertController = UIAlertController(title: "Location",
                                        message: "Please enter your approximate address and/0 zip code",
                                        preferredStyle: .Alert)
    alertController!.addTextFieldWithConfigurationHandler(
        {(textField: UITextField!) in
            textField.placeholder = "Enter Address"
    })
    let action = UIAlertAction(title: "Submit",
                               style: UIAlertActionStyle.Default,
                               handler: {[weak self]
                                (paramAction:UIAlertAction!) in
                                if let textFields = alertController?.textFields{
                                    
                                    let theTextFields = textFields as [UITextField]
                                    let enteredText = theTextFields[0].text
                                    self?.zip = enteredText!
                                }
        })
    
    alertController?.addAction(action)
    self.presentViewController(alertController!,
                               animated: true,
                               completion: nil)
    let zipCode = CLGeocoder().geocodeAddressString(self.zip, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
        if let placemark = placemarks?.first {
            
            self.dataStore.currentLocation = placemark.location!
            print(self.dataStore.currentLocation)
            
        }
    })
}

func getCoordinatesFromZipCode(zip: String) {
    
    let zipCode = CLGeocoder().geocodeAddressString(zip, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
        if let placemark = placemarks?.first {
            
            self.dataStore.currentLocation = placemark.location!
            print(self.dataStore.currentLocation)
            
        }
    })
}

}