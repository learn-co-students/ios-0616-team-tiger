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
    var zip : String = ""
    
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
                self.getParks({ 
                    self.dataStore.parkTypeArray = self.sortArrayByDistance(self.dataStore.parkTypeArray)
                    for park in self.dataStore.parkTypeArray {
                        self.arrayOfParks.append(park["name"] as! String)
                    }
                })
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
    
    func isLessThan5MilesAway(array : [[String: AnyObject]]) -> [[String: AnyObject]] {
        let arrayCopy = array.filter({ ($0["Distance"] as! Double) < 5.0 })
        return arrayCopy
    }
    
    func sortArrayByDistance(array : [[String : AnyObject]]) -> [[String : AnyObject]] {
        let sortedByDistance = array.sort { ($0["Distance"] as! Double) < ($1["Distance"] as! Double) }
//        print("Sortedsortedsorted \(sortedByDistance)")
        return sortedByDistance
    }
    
    // Parks
    func getParks(completion: () -> ()) {
        print("Get parks")
        
        dataStore.populateParkByTypeBasedOnState("type", type: "Garden") {
            
            
            
            completion()
        }
    }
    // Farmers' Market
    
    // Tweaked to get hours and season of operation
    func getFarmersMarkets() {
        
        dataStore.farmersMarketParse { completion in
            if completion {

                
//                self.farmersMarketThings({ // comment out to run on simulator
                    for marketDictionary in self.dataStore.farmersMarketArray {
                        
                        if let marketName = marketDictionary["name"] {
                            self.arrayOfFarmersMarkets.append(marketName as! String)
                            print(marketName)
                        }
                    }
                    
                    print("FarmersMarketsArray1 : \(self.dataStore.farmersMarketArray)")
                    print("farmersmarketnames: \(self.arrayOfFarmersMarkets)")
//                }) comment out to run on simulator
                            } else {
                print("ERROR: Unable to retrieve farmer's markets")
            }
            
        }
//        print("FarmersMarketsArray2 : \(self.dataStore.farmersMarketArray)")
    }
    
    func farmersMarketThings(completion : () -> ()) {
        var farmersArrayCopy : [[String : AnyObject]] = []
//        print(self.dataStore.farmersMarketArray)
        for market in self.dataStore.farmersMarketArray {
            if let location = self.locationManager.location {
                
                let distance = ((market["coordinates"] as! CLLocation).distanceFromLocation(location) * 0.00062137)
                var marketCopy = market
                marketCopy.updateValue(distance, forKey: "Distance")
                farmersArrayCopy.append(marketCopy)
                print(marketCopy)
            }
        }
        
        self.dataStore.farmersMarketArray = self.sortArrayByDistance(farmersArrayCopy)
        self.dataStore.farmersMarketArray = self.isLessThan5MilesAway(self.dataStore.farmersMarketArray)
        completion()
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
        } else if segue.identifier == "showShops" {
            destinationVC.arrayOfNames = self.arrayOfFarmersMarkets
        } else {
            destinationVC.arrayOfNames = self.arrayOfParks
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
            self.getCoordinatesFromZipCode(self.getZipCode())
            print("No go on location")
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            dataStore.currentLocation = (locations.first)!
            locationManager.stopUpdatingLocation()
            print("We know where you are")
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func getZipCode() -> String {
        var alertController:UIAlertController?
        alertController = UIAlertController(title: "Location",
                                            message: "Please enter your approximate address and zip code",
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
        return self.zip
    }
    
    func getCoordinatesFromZipCode(zip: String) {
    
            let zipCode = CLGeocoder().geocodeAddressString(zip, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                if let placemark = placemarks?.first {
                    
                    self.dataStore.currentLocation = placemark.location!
//                    print(self.dataStore.currentLocation)
                    
                }
            })
    }
}