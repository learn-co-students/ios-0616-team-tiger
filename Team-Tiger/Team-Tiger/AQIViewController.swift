//
//  AQIViewController.swift
//  Team-Tiger
//
//  Created by Kenneth Cooke on 8/18/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import UIKit

class AQIViewController: UIViewController {
    
    @IBOutlet weak var ozoneLabel: UILabel!
    @IBOutlet weak var particulateLabel: UILabel!
    @IBOutlet weak var actionDayStatus: UITextView!
    
    var airQualityReport: [[String : AnyObject]] = []
    
    let dataStore = DataStore.store
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
}
