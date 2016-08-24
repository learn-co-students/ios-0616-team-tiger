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

class AQIViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var ozoneLabel: UILabel!
    @IBOutlet weak var particulateLabel: UILabel!
    @IBOutlet weak var actionDayStatus: UITextView!
    
    @IBOutlet weak var letsGo: UIButton!
    var airQualityReport: [[String : AnyObject]] = []
    let locationManager = CLLocationManager()
    let dataStore = DataStore.store
//    var reachability: Reachability?

    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.getLocation()
    self.airQualityReport = dataStore.airQualityReport as! [[String : AnyObject]]
        
        let ozoneIndex = self.airQualityReport.count - 2
        if InternetStatus.shared.hasInternet {
        if let ozone = self.airQualityReport[ozoneIndex]["AQI"] {
            
            self.ozoneLabel.text = "\(ozone)"
            
        } else {
            self.ozoneLabel.text = "0"
            
        }
        
        let particulateIndex = self.airQualityReport.count - 1
        
        if let particulate = self.airQualityReport[particulateIndex]["AQI"] {
            
            self.particulateLabel.text = "\(particulate)"
            
        } else {
            self.particulateLabel.text = "0"
        }
        
        if let actionDayStatus = self.airQualityReport[particulateIndex]["ActionDay"] {
            
            if String(actionDayStatus) == "1" {
                
                self.actionDayStatus.text = "It's an Air Quality Action Day. Groups that are sensitive to certain pollutants should reduce exposure by eliminating prolonged or heavy exertion outdoors. For ozone this includes children and adults who are active outdoors and people with lung disease, such as asthma."
                
            } else {
                
                self.actionDayStatus.text = "It's not an Air Quality Action Day. Enjoy the fresh air!"
                
            }
            }
            
        } else {
            self.ozoneLabel.text = "N/A"
            self.particulateLabel.text = "N/A"
            self.actionDayStatus.text = "Sorry, we cannot currently access Air Quality data. Please make sure you're connected to the internet, restart the app, and try again."
            self.letsGo.hidden = true
        }
        
            
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
//        self.getLocation()
    }
    
    
    func showAlertToGetLocation() {
        let alertController = UIAlertController(title: "Location Needed",
                                                                         message: "The location services permission was not authorized. Please enable it in Settings to continue.",
                                                                         preferredStyle: .Alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .Default) { (alertAction) in
            
            if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(appSettings)
            }
        }
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "No Thanks", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        
        presentViewController(alertController, animated: true, completion: nil)
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
