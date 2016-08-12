//
//  ButtonsViewController.swift
//  Team-Tiger
//
//  Created by Kenneth Cooke on 8/12/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import UIKit

class ButtonsViewController: UIViewController {
    
    var FMdictionary = [:]
    var dictionaryWithInfo = [String:String]()
    var farmersMarketArray: [[String:String]] = []
    var arrayOfNames: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    @IBAction func shopTapped(sender: AnyObject) {
        
        fmParse { completion in
            
            if completion {
                for marketDictionary in self.farmersMarketArray {
                    if let marketName = marketDictionary["name"] {
                        self.arrayOfNames.append(marketName)
                    }
                }
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.tableView.reloadData()
                })
            } else {
                print("ERROR: Unable to retrieve farmer's markets")
            }
            
        }
    }
    
    func fmParse(completionHandler: (Bool) -> ()) {
        
        
        Alamofire.request(.GET, "https://data.cityofnewyork.us/api/views/j8gx-kc43/rows.json?") .responseJSON { response in
            self.FMdictionary = response.result.value as! NSDictionary
            
            if let jsonData = response.data {
                let jsonObj = JSON(data: jsonData)
                
                let arrayOfData = jsonObj["data"].array
                
                if let arrayOfData = arrayOfData {
                    
                    for detail in arrayOfData {
                        
                        self.dictionaryWithInfo["name"] = detail[8].string
                        self.dictionaryWithInfo["zip"] = detail[13].string
                        self.dictionaryWithInfo["longitude"] = detail[15].string
                        self.dictionaryWithInfo["latitude"] = detail[14].string
                        
                        if let addressInDictionary = detail[10].string {
                            
                            self.dictionaryWithInfo["address"] = addressInDictionary
                            
                        } else {
                            print("IN SEARCH OF ADDRESS")
                        }
                        
                        self.farmersMarketArray.append(self.dictionaryWithInfo)
                        
                    }
                    completionHandler(true)
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destinationVC = segue.destinationViewController as! SearchResultsTableViewController
        
        destinationVC.arrayOfNames = self.arrayOfNames
        
    }



}
