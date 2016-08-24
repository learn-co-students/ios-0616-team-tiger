//
//  ReloadViewController.swift
//  Team-Tiger
//
//  Created by Kenneth Cooke on 8/24/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import CoreLocation
import ReachabilitySwift
import NVActivityIndicatorView

class ReloadViewController: UIViewController, CLLocationManagerDelegate, NVActivityIndicatorViewable {
    
    
    let dataStore = DataStore.store
    let locationManager = CLLocationManager()
    
    var window: UIWindow?
    var zip : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let timer = NSTimer(timeInterval: 5.0, target: self, selector: #selector(pushToAQIViewController), userInfo: nil, repeats: false)
        
        startActivityAnimating(CGSizeMake(120, 120), message: "connecting", type: .BallRotateChase, color: UIColor.whiteColor())
        
        
        ReachabilityCheck().reachabilitySetup()
        
        AirQualityAPIClient.getAirQualityIndex("10012") { (report) in
            self.dataStore.airQualityReport = report
            
//            self.stopActivityAnimating()
            
            let aqi = self.storyboard?.instantiateViewControllerWithIdentifier("aqi")
            
            self.presentViewController(aqi!, animated: true, completion: nil)
            
            
        }
        
        //Gathers initial park data
        self.getLocation()
        dataStore.fetchData()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        startActivityAnimating(CGSizeMake(120, 120), message: "Connecting", type: .BallRotateChase, color: UIColor.whiteColor())
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(pushToAQIViewController), userInfo: nil, repeats: false)
        
        
        
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
    
    func getLocation() {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
            self.dataStore.hasLocation = true
        } else {
            
            print("No go on location")
            
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("We know where you are")
        
        if locations.count > 0 {
            
            dataStore.currentLocation = (locations.first)!
            
            locationManager.stopUpdatingLocation()
            self.dataStore.hasLocation = true
            //            print("You are here : \(dataStore.currentLocation)")
            
        }
        
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func pushToAQIViewController() {
        
        stopActivityAnimating()
        
        
        let aqi = self.storyboard?.instantiateViewControllerWithIdentifier("aqi")
        
        self.presentViewController(aqi!, animated: true, completion: nil)
        
        
    }
    
}
