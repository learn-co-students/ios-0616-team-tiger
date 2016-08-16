//
//  ViewController.swift
//  Team-Tiger
//
//  Created by Kenneth Cooke on 8/4/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import UIKit
import Alamofire
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let dataStore = DataStore.store

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
            }
    
    override func viewWillAppear(animated: Bool) {
        
        
        dataStore.populateParkByTypeBasedOnState("type", type: "Garden") {
            //            print(apiClient.typeResults)
            let sortByDistance = NSSortDescriptor(key: "Distance", ascending: true)
            var tableViewArray : NSArray = self.dataStore.parkTypeArray
            tableViewArray = tableViewArray.sortedArrayUsingDescriptors([sortByDistance])
            print("Maybe sorted \(tableViewArray)")
            
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } 
}

//class PendingOperations {
//    
//lazy var generateParksData = [NSIndexPath:NSOperation]()
//    lazy var parksQueue:NSOperationQueue = {
//        var queue = NSOperationQueue()
//        queue.name = "Generate Location Queue"
//        queue.maxConcurrentOperationCount = 1
//        return queue
//    }()
//    
//    
