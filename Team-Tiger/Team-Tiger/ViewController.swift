//
//  ViewController.swift
//  Team-Tiger
//
//  Created by Kenneth Cooke on 8/4/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    var screenWidth: CGFloat = 0.0
    var screenHeight:CGFloat = 0.0
    
    
    @IBOutlet weak var rest: UIButton!
    
    let dataStore = DataStore.store

    override func viewDidLoad() {
        super.viewDidLoad()
        view.removeConstraints(view.constraints)
        rest.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGrayColor()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height

        
        rest.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 0).active = true
        
        rest.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: 0).active = true
        rest.heightAnchor.constraintEqualToAnchor(view.heightAnchor, multiplier: 0.33).active = true
        rest.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 0).active = true
        rest.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: 0).active = true
        
        
//        let keys = Array(dataStore.parsedParksDictionary.keys)
//        
//        var gardens: [[String : String]] = []
//        
//        for key in keys {
//            
//            if dataStore.parsedParksDictionary[key]!["type"] == "garden" {
//                
//                gardens.append(dataStore.parsedParksDictionary[key]!)
//                
//                
//            }
//            print(gardens)
//            
//        }
        
    
        
        // Do any additional setup after loading the view, typically from a nib.
        
//        var gardens: [[String : String]] = []
//        
//        for location in (dataStore.parsedParksDictionary as Dictionary) {
//            
//            let dictionary = Dictionary(dictionaryLiteral: location)
//            if location["type"] = "garden" {
//                
//            gardens.append(location)
//                
//                
//            }
        
//        }
        
        
    }
    
    @IBAction func restButton(sender: UIButton) {
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

