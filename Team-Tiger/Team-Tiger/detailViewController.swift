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
       // self.locationName.text = locationNameText
   
        locationName.text =  dictionaryOfData["name"] as! String
        locationAddress.text =  dictionaryOfData["address"] as! String
        locationType.text =  dictionaryOfData["type"] as! String
        zipCode.text =  dictionaryOfData["zip"] as! String
        
        print("Addresses of parks: \(locationAddress.text)")
       print(dictionaryOfData)
            
    
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
