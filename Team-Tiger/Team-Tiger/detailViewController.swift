//
//  detailViewController.swift
//  Team-Tiger
//
//  Created by Ehsan Zaman on 8/14/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation


class detailViewController: UIViewController {
    
    @IBOutlet weak var saveFavorites: UIButton!
    
    
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationAddress: UILabel!
    @IBOutlet weak var locationType: UILabel!
    @IBOutlet weak var zipCode: UILabel!
    @IBOutlet weak var saveFavoriteButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var season: UILabel!
    @IBOutlet weak var hours: UILabel!
    
    var locationToPresent: [String : AnyObject] = [:]
    var passedDataType: String = ""
    
    @IBOutlet weak var phoneButton: UIButton!
    
    var favoriteToPresent: Location? = nil
    
    let dataStore = DataStore.store
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(red: 125.0/255, green: 181.0/255, blue: 107.0/255, alpha: 100.0)
        
        setViewLabelsBasedOnPassedType()
        
        if favoriteToPresent == nil {
            
            let stringOfCoordinates = locationToPresent["coordinates"]
            let latitudeAsString = stringOfCoordinates!.coordinate.latitude as Double
            let longitudeAsString = stringOfCoordinates!.coordinate.longitude as Double
            
            let latDelta = 0.015
            let longDelta = 0.015
            
            let span = MKCoordinateSpanMake(latDelta, longDelta)
            
            let location = CLLocationCoordinate2D(latitude: latitudeAsString , longitude: longitudeAsString)
            
            let region = MKCoordinateRegion(center: location, span: span)
            
            mapView.setRegion(region, animated: true)
            //PIN
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            
            if self.passedDataType == "gardens" {
                
                annotation.title = locationToPresent["Garden"] as? String
                
            } else {
                
                annotation.title = locationToPresent["name"] as? String
                
            }
            
            mapView.addAnnotation(annotation)
            mapView.selectAnnotation(annotation, animated: true)
            
            mapView.addAnnotation(annotation)
            
            
            if locationToPresent["hours"] != nil {
                hours.text = locationToPresent["hours"] as? String }
            else {
                hours.text = ""
            }
            if locationToPresent["season"] != nil  {
                season.text = locationToPresent["season"] as? String
            } else {
                season.text = ""
            }
            
            
        }
        
        if locationToPresent["phone number"] != nil {
            
            let number = (locationToPresent["phone number"]! as! String).stringByReplacingOccurrencesOfString(" ", withString: "")
            
            // use regex for phone numbers
            if number.characters.count > 8 {
                phoneButton.hidden = false
                phoneButton.enabled = true
                
                
            } else {
                phoneButton.hidden = true
                phoneButton.enabled = false
            }
        }
        else {
            phoneButton.hidden = true
            phoneButton.enabled = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func setViewLabelsBasedOnPassedType() {
        
        if self.passedDataType == "parks" {
            
            setupUpParkLabels()
            
        } else if self.passedDataType == "markets" {
            
            setupMarketLabels()
            
        } else if self.passedDataType == "gardens" {
            
            setupGardenLabels()
            
        } else {
            
            if let favorite = self.favoriteToPresent {
                
                self.locationName.text = favorite.name
                self.locationAddress.text = favorite.address
                self.zipCode.text = favorite.zip
                self.locationType.text = favorite.type
                self.saveFavoriteButton.hidden = true
            }
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay) //Creates overlay
        circleRenderer.strokeColor = UIColor(red: 0.094, green:0.655, blue:0.710, alpha:1.0) //Teal circle
        circleRenderer.fillColor = UIColor(red: 0.094, green:0.655, blue:0.710, alpha:0.15) //Slightly transparent teal
        circleRenderer.lineWidth = 0.1
        return circleRenderer
        
    }
    
    //    func loadOverlayForRegionWithLatitude(latitude: Double, andLongitude longitude: Double) {
    //
    //
    //        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    //
    //       var circle = MKCircle(centerCoordinate: coordinates, radius: 50)
    //
    //
    //        self.mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 7, longitudeDelta: 7)), animated: true)
    //
    //        self.mapView.addOverlay(circle)
    //    }
    
    func setupUpParkLabels() {
        
        
        if let favorite = self.favoriteToPresent {
            
            self.locationName.text = favorite.name
            self.locationAddress.text = favorite.address
            self.zipCode.text = favorite.zip
            self.locationType.text = favorite.type
            self.saveFavoriteButton.hidden = true
            self.season.hidden = true
            self.hours.hidden = true
            
            
        } else {
            
            let type = locationToPresent["type"] as! String
            
            if locationToPresent["name"] != nil {
                
                locationName.text =  (locationToPresent["name"] as! String)
            } else {
                locationName.text = ""
            }
            
            if locationToPresent["address"] != nil {
                locationAddress.text =  (locationToPresent["address"] as! String)
                
                //            //            if locationToPresent["name"] != nil {
                //            locationName.text =  (locationToPresent["name"] as? String)
                //            //            } else {
                //            //                locationName.text = ""
                //            //            }
                //
                //            if locationToPresent["address"] != nil {
                //                locationAddress.text =  (locationToPresent["address"] as? String)
                
            } else {
                locationAddress.text = ""
            }
            
            //to replace after kens icons populate tableview
            //        if type.containsString("Garden") {
            //            type = type + " 🌿"
            //        }
            locationType.text = type
            
            if locationToPresent["zip"] != nil {
                
                zipCode.text =  (locationToPresent["zip"] as! String)
                
            } else {
                zipCode.text = ""
            }
        }
    }
    
    func setupMarketLabels() {
        if (locationToPresent["name"] as! String).characters.count > 0 {
            locationName.text =  (locationToPresent["name"] as! String)
        } else {
            locationName.text = ""
        }
        if (locationToPresent["address"] as! String).characters.count > 0 {
            locationAddress.text =  (locationToPresent["address"] as! String)
        } else {
            locationAddress.text = ""
        }
        
        locationType.text = "Farmer's Market"
        
        if (locationToPresent["zip"] as! String).characters.count > 4 {
            zipCode.text =  (locationToPresent["zip"] as! String)
        } else {
            zipCode.text = ""
        }
    }
    
    func setupGardenLabels() {
        if (locationToPresent["Garden"] as! String).characters.count > 0 {
            locationName.text =  (locationToPresent["Garden"] as! String)
        } else {
            locationName.text = ""
        }
        if (locationToPresent["Address"] as! String).characters.count > 0 {
            locationAddress.text =  (locationToPresent["Address"] as! String)
        } else {
            locationAddress.text = ""
        }
        
        zipCode.text = ""
        locationType.text = "Garden"
    }
    
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluateWithObject(value)
        return result
    }
    
    @IBAction func phoneNumber(sender: AnyObject) {
        if locationToPresent["phone number"] != nil {
            let url: NSURL = NSURL(string: "tel://\(locationToPresent["phone number"]!)")!
            
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    
    @IBAction func saveToFavoritesTapped(sender: AnyObject) {
        
        
        let newFavorite = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: dataStore.managedObjectContext) as! Location
        
        //gardens don't have a name, they have "Garden" as their key
        
        
        if self.passedDataType == "gardens" {
            
            newFavorite.name = (locationToPresent["Garden"] as! String)
            newFavorite.address = (locationToPresent["Address"] as! String)
            
            if let phone = locationToPresent["phone number"] {
                
                newFavorite.phone = (phone as! String)
                
            }
            
        } else {
            
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
            
        }
        
        newFavorite.user = dataStore.user[0]
        
        //dataStore.user[0].favorites?.setByAddingObject(newFavorite)
        
        dataStore.saveContext()
        dataStore.fetchData()
        
        
        //        print(dataStore.user[0].favorites?.count)
        
        
    }
    
}