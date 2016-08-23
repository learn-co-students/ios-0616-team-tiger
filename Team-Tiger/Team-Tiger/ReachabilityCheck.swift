//
//  ReachabilityCheck.swift
//  Team-Tiger
//
//  Created by Jordan Kiley on 8/22/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import Foundation
import ReachabilitySwift
import UIKit

class ReachabilityCheck {
    var reachability : Reachability?
    
    func reachabilitySetup() {
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch let error as NSError {
            print("Unable to start reachability \(error.localizedDescription)")
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(reachabilityCheck()), name: ReachabilityChangedNotification, object: reachability)
        do {
            
            try reachability?.startNotifier()
            
        } catch let error as NSError {
            
            print("Unable to start notifier \(error.localizedDescription)")
        }
    }
    
    func reachabilityCheck() {
        
        guard let reachability = reachability else { return }
        let status = InternetStatus.shared
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                
                status.hasInternet = true
                print("Reachable via WiFi")
                
            } else {
                
                status.hasInternet = true
                print("Reachable via Cellular")
            }
        } else {
            
            status.hasInternet = false
            print("Network not reachable")
        }
    }
}

class InternetStatus {
    
    var hasInternet: Bool = false
    static let shared = InternetStatus()
    private init() {}
    
}