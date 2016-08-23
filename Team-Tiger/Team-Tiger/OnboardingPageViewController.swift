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
    
    let textArray = ["Greenway is designed to help you find the nearest green space to unwind in. Whether it's a place to shop, read a book, or eat your lunch, we've got you covered.", "Just choose what you're looking for...", "...and we'll display results arranged by distance."]
    
    var backgroundImageArray: [UIImage] = []
    var screenShotArray: [UIImage] = []
    
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
        
        if index >= self.backgroundImageArray.count {
            
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
            
            view.imageForBackground = self.backgroundImageArray[index]
            
            view.controllerIndex = index
            
            if view.controllerIndex == 2 {
                
                view.buttonHidden = false
                view.swipeHidden = true
                
            }
            
            if view.controllerIndex != 0 {
                
                view.screenShot = self.screenShotArray[index - 1]

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
            

            self.backgroundImageArray.append(flower)
            self.backgroundImageArray.append(plant)
            self.backgroundImageArray.append(bench)
            
        }
        
        let photo2 = UIImage(named: "onboarding1")
        let photo3 = UIImage(named: "onboarding2")
        
        if let photo2 = photo2, photo3 = photo3 {
            
            self.screenShotArray = [photo2, photo3]
            
        }
        
        
        
        
    }
}
