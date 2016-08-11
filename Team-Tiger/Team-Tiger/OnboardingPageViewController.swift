////
////  OnboardingPageViewController.swift
////  Team-Tiger
////
////  Created by Kenneth Cooke on 8/9/16.
////  Copyright © 2016 kencooke. All rights reserved.
////

import UIKit
import MapKit

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, CLLocationManagerDelegate {
    
    let textArray = ["Greenway loves you!", "Really, I do!", "Don't you sometimes feel like our time together is all too short?"]
    
    var imageArray: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self

        providePhotos()
        
        let initialViewController = self.viewControllerAtIndex(0)
        
        self.setViewControllers([initialViewController!], direction: .Forward, animated: true, completion: nil)
        
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! onboardingViewController).controllerIndex
        
        if index <= 0 {
            
            return nil
            
        }
        
        index = index! - 1
        
        return self.viewControllerAtIndex(index!)
        
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! onboardingViewController).controllerIndex
        
        if index >= self.imageArray.count {
            
            return nil
            
        }
        
        index = index! + 1
        
        return self.viewControllerAtIndex(index!)
        
        
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        
        if((self.textArray.count == 0) || (index >= self.textArray.count)) {
            
            return nil
            
        }
        
        let viewControllerToDisplay = self.storyboard?.instantiateViewControllerWithIdentifier("onboarding") as? onboardingViewController
        
        if let view = viewControllerToDisplay {
            
            view.textToDisplay = self.textArray[index]
            
            view.imageForBackground = self.imageArray[index]
            
            view.controllerIndex = index
            
            if view.controllerIndex == 2 {
                
                view.buttonHidden = false
                
            }
            
            return view
            
        }
        
        return nil
    }
    
    func providePhotos() {
        
        let benchPhoto = UIImage.init(named: "blurredBench")
        let plantPhoto = UIImage.init(named: "blurredPlant")
        let flowerPhoto = UIImage.init(named: "blurredFlowers")
        
        if let bench = benchPhoto, flower = flowerPhoto, plant = plantPhoto {
            
            
            self.imageArray.append(flower)
            self.imageArray.append(plant)
            self.imageArray.append(bench)
            
        }
    }
    
}
