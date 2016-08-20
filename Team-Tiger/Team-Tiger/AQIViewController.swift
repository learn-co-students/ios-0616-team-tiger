//
//  AQIViewController.swift
//  Team-Tiger
//
//  Created by Kenneth Cooke on 8/18/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import UIKit
import SystemConfiguration
import CoreLocation
import ReachabilitySwift

class AQIViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var ozoneLabel: UILabel!
    @IBOutlet weak var particulateLabel: UILabel!
    @IBOutlet weak var actionDayStatus: UITextView!
    
    var airQualityReport: [[String : AnyObject]] = []
    let locationManager = CLLocationManager()
    let dataStore = DataStore.store
    var reachability: Reachability?

    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.getLocation()
        self.airQualityReport = dataStore.airQualityReport as! [[String : AnyObject]]
        
        let ozoneIndex = self.airQualityReport.count - 2
        
        if let ozone = self.airQualityReport[ozoneIndex]["AQI"] {
            
            self.ozoneLabel.text = "\(ozone)"
            
        }
        
        let particulateIndex = self.airQualityReport.count - 1
        
        if let particulate = self.airQualityReport[particulateIndex]["AQI"] {
            
            self.particulateLabel.text = "\(particulate)"
            
        }
        
        if let actionDayStatus = self.airQualityReport[particulateIndex]["ActionDay"] {
            
            if String(actionDayStatus) == "1" {
                
                self.actionDayStatus.text = "It's an Air Quality Action Day. Groups that are sensitive to certain pollutants should reduce exposure by eliminating prolonged or heavy exertion outdoors. For ozone this includes children and adults who are active outdoors and people with lung disease, such as asthma."
                
            } else {
                
                self.actionDayStatus.text = "It's not an Air Quality Action Day. Enjoy the fresh air!"
                
            }
            
        } else {
            
            self.actionDayStatus.text = "Sorry, we cannot currently access Air Quality data. Please make sure you're connected to the internet and try again."
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:",name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.getLocation()
    }
    func getLocation() {
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        if !dataStore.hasLocation {
            
            self.showAlertAppDelegate()
            print(self.dataStore.currentLocation)
            
        }
    }
    
    
    func showAlertAppDelegate() {let alertController = UIAlertController(title: "Location Needed",
                                                                         message: "The location services permission was not authorized. Please enable it in Settings to continue.",
                                                                         preferredStyle: .Alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .Default) { (alertAction) in
            
            if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(appSettings)
            }
        }
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        
        presentViewController(alertController, animated: true, completion: nil)
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
    
    // Reachability shtuff
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            print("Network not reachable")
        }
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
