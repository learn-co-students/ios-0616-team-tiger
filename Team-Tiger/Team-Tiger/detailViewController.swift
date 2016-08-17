//
//  detailViewController.swift
//  Team-Tiger
//
//  Created by Ehsan Zaman on 8/14/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import UIKit


class detailViewController: UIViewController {
   
    
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationAddress: UILabel!
    @IBOutlet weak var locationType: UILabel!
    @IBOutlet weak var zipCode: UILabel!
    
    var dictionaryOfData: [String : AnyObject] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(red: 125.0/255, green: 181.0/255, blue: 107.0/255, alpha: 100.0)
        
        // self.locationName.text = locationNameText

        var type = dictionaryOfData["type"] as! String
        locationName.text =  dictionaryOfData["name"] as? String
        locationAddress.text =  dictionaryOfData["address"] as? String
       
        //to replace after kens icons populate tableview
        if type.containsString("Garden") {
            type = type + " 🌿"
        }
        locationType.text = type
        zipCode.text =  dictionaryOfData["zip"] as? String
        
        print("Addresses of parks: \(locationAddress.text)")
        print(dictionaryOfData)
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func phoneNumber(sender: AnyObject) {
        let url: NSURL = NSURL(string: "tel://3472321892")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    
    
   
}
