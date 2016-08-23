import UIKit
import Alamofire
import SwiftyJSON
import MapKit
import CoreData
import Foundation
import NVActivityIndicatorView

class ButtonsViewController: UIViewController, CLLocationManagerDelegate, NVActivityIndicatorViewable {
    var FMdictionary = []
    var dictionaryWithInfo = [String:AnyObject]()
    var farmersMarketArray: [[String:AnyObject]] = []
    var arrayOfFarmersMarkets: [String] = []
    var arrayOfParks: [String] = []
    var arrayOfGardens : [String] = []
    let locationManager = CLLocationManager()
    
    
    let dataStore = DataStore.store
    
    var zip : String = ""
    
    var distanceForParks : [String] = []
    var distanceForGardens : [String] = []
    var distanceForMarkets : [String] = []
    
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    var queue = NSOperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        startActivityAnimating(CGSizeMake(120, 120), message: "Loading", type: .BallRotateChase, color: UIColor.whiteColor())
        
        self.blurEffect.layer.cornerRadius = 10
        self.blurEffect.clipsToBounds = true
        self.dataStore.parkTypeArray = self.sortArrayByDistance(self.dataStore.parkTypeArray)
        
//        dataStore.getLinkNYCWifiSpots()

        
        dataStore.populateParkByTypeBasedOnState("type", type: "Park") { (success) in
            
            if success {
                self.dataStore.parkTypeArray = self.sortArrayByDistance(self.dataStore.parkTypeArray)
                for park in self.dataStore.parkTypeArray {
                    self.arrayOfParks.append((park["name"] as? String)!)
                    let distance = park["Distance"] as? Double
                    let distanceAsString = String(format: "%.1f mi", distance!)
                    //                    print(distanceAsString)
                    self.distanceForParks.append(distanceAsString)
                    
                }
                print("Got parks")
                self.stopActivityAnimating()
            }
        }
        print("All the parks")
        self.getFarmersMarkets()
        print("Farmers markets")
        self.getGardens { (true) in
            
            
        }
        print("Wifi Found")
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
        if array.first?["Distance"] == nil {
            var arrayCopy : [[String : AnyObject]] = []
            for park in array {
                var parkCopy = park
                if let coordinate = parkCopy["coordinates"] {
                    //                    print(coordinate.distanceFromLocation(self.dataStore.currentLocation))
                    parkCopy["Distance"] = (coordinate.distanceFromLocation(self.dataStore.currentLocation)) * 0.00062137
                    arrayCopy.append(parkCopy)
                }
            }
            let sortedByDistance = arrayCopy.sort { ($0["Distance"] as! Double) < ($1["Distance"] as! Double) }
            return sortedByDistance
            
        } else {
            let sortedByDistance = array.sort { ($0["Distance"] as! Double) < ($1["Distance"] as! Double) }
            //        print("Sortedsortedsorted \(sortedByDistance)")
            return sortedByDistance
        }
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
                    let distance = (coordinates.distanceFromLocation(self.dataStore.currentLocation) * 0.00062137)
                    var marketCopy = market
                    marketCopy.updateValue(distance, forKey: "Distance")
                    farmersArrayCopy.append(marketCopy)
                    
                }
                self.dataStore.farmersMarketArray = self.sortArrayByDistance(farmersArrayCopy)
                self.dataStore.farmersMarketArray = self.isLessThan5MilesAway(self.dataStore.farmersMarketArray)
                
                for marketDictionary in self.dataStore.farmersMarketArray {
                    
                    if let marketName = marketDictionary["name"] {
                        self.arrayOfFarmersMarkets.append(marketName as! String)
                        let distance = marketDictionary["Distance"] as? Double
                        let distanceAsString = String(format: "%.1f mi", distance!)
                        //                        print(distanceAsString)
                        self.distanceForMarkets.append(distanceAsString)
                    }
                }
            } else {
                print("ERROR: Unable to retrieve farmer's markets")
            }
        }
    }
    

    @IBAction func shopTapped(sender: AnyObject) {
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destinationVC = segue.destinationViewController as! SearchResultsTableViewController
        
        if segue.identifier == "showParks" {
            
            destinationVC.arrayOfNames = self.arrayOfParks
            
            destinationVC.displayedDataType = "parks"
            destinationVC.arrayOfNames = self.arrayOfParks
            destinationVC.arrayOfDistance = self.distanceForParks

        } else if segue.identifier == "showShops" {
            
            destinationVC.arrayOfNames = self.arrayOfFarmersMarkets
            destinationVC.displayedDataType = "markets"
            destinationVC.arrayOfDistance = self.distanceForMarkets

        } else {
            
            destinationVC.arrayOfNames = self.arrayOfGardens
            
            destinationVC.displayedDataType = "gardens"
            destinationVC.arrayOfDistance = self.distanceForGardens

        }
    }
    
    func getGardens(completion: (Bool) -> ()) {
        dataStore.greenThumbParse({ (true) in
            self.dataStore.greenThumbArray = self.sortArrayByDistance(self.dataStore.greenThumbArray)
            for garden in self.dataStore.greenThumbArray {
                self.arrayOfGardens.append(garden["Garden"] as! String)
                let distance = garden["Distance"] as? Double
                let distanceAsString = String(format: "%.1f mi", distance!)
                self.distanceForGardens.append(distanceAsString)
            }
            completion(true)
        })
    }

    
//    func getZipCode() {
//        var alertController:UIAlertController?
//        alertController = UIAlertController(title: "Location",
//                                            message: "Please enter your approximate address and/0 zip code",
//                                            preferredStyle: .Alert)
//        alertController!.addTextFieldWithConfigurationHandler(
//            {(textField: UITextField!) in
//                textField.placeholder = "Enter Address"
//        })
//        let action = UIAlertAction(title: "Submit",
//                                   style: UIAlertActionStyle.Default,
//                                   handler: {[weak self]
//                                    (paramAction:UIAlertAction!) in
//                                    if let textFields = alertController?.textFields{
//                                        
//                                        let theTextFields = textFields as [UITextField]
//                                        let enteredText = theTextFields[0].text
//                                        self?.zip = enteredText!
//                                    }
//            })
//        
//        alertController?.addAction(action)
//        self.presentViewController(alertController!,
//                                   animated: true,
//                                   completion: nil)
//        let zipCode = CLGeocoder().geocodeAddressString(self.zip, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
//            if let placemark = placemarks?.first {
//                
//                self.dataStore.currentLocation = placemark.location!
//                //                print(self.dataStore.currentLocation)
//                
//            }
//        })
//    }
//    
//    func getCoordinatesFromZipCode(zip: String) {
//        
//        let zipCode = CLGeocoder().geocodeAddressString(zip, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
//            if let placemark = placemarks?.first {
//                
//                self.dataStore.currentLocation = placemark.location!
//                //                print(self.dataStore.currentLocation)
//                
//            }
//        })
//        //        print(zipCode)
//    }
    

}