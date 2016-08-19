//
//  AirQualityAPIClient.swift
//  Team-Tiger
//
//  Created by Kenneth Cooke on 8/10/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import Foundation
import Alamofire

class AirQualityAPIClient {
    
    let dataStore = DataStore.store
    
    static var isActionDay: Bool = false
    
    
    class func getAirQualityIndex(zipcode: String, Completion: (report: NSArray) -> ()) {
        
        let parametersDictionary = ["zipCode":zipcode,
                                    "format":"application/json",
                                    "api_key": Secrets.airAPIKey]
        
        Alamofire.request(.GET, "https://airnowapi.org/aq/forecast/zipCode/", parameters: parametersDictionary, encoding: .URL).responseJSON { (response) in
            
            
            
            if let forecast = response.result.value as! NSArray? {
                
            
//            print(forecast)
            
            for dataSet in forecast {
                
                if let actionDayStatus = dataSet["ActionDay"] {
                    
                    if String(actionDayStatus!) == "1" {
                        
                        self.isActionDay = true
                        
//                        print("It's an AQI Action Day. Groups that are sensitive to the pollutant should reduce exposure by eliminating prolonged or heavy exertion outdoors. For ozone this includes children and adults who are active outdoors and people with lung disease, such as asthma.")
                        
                        break
                        
                    } else {
                        
//                        print("It's not an AQI Action Day. Enjoy the clean air!")
                        
                    }
                    
                } else {
                    
//                    print("Sorry, we cannot currently access Air Quality data")
                    
                }
                
                Completion(report: forecast)
                
                }
            }
            
        }
        
    }
    
    
}
