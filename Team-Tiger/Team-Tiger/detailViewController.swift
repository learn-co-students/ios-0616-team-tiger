//
//  detailViewController.swift
//  Team-Tiger
//
//  Created by Ehsan Zaman on 8/14/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import UIKit
import CoreData


class detailViewController: UIViewController {
    
//business 6
    @IBOutlet weak var businessViewSix: UIView!
    @IBOutlet weak var distanceSix: UILabel!
    @IBOutlet weak var businessSix: UILabel!
    @IBOutlet weak var imageSix: UIImageView!
    @IBOutlet weak var ratingSix: UIImageView!
    
//business 5
    @IBOutlet weak var businessViewFive: UIView!
    @IBOutlet weak var distanceFive: UILabel!
    @IBOutlet weak var businessFive: UILabel!
    @IBOutlet weak var imageFive: UIImageView!
    @IBOutlet weak var ratingFive: UIImageView!
    
//business 4
    @IBOutlet weak var businessViewFour: UIView!
    @IBOutlet weak var ratingFour: UIImageView!
    @IBOutlet weak var imageFour: UIImageView!
    @IBOutlet weak var businessFour: UILabel!
    @IBOutlet weak var distanceFour: UILabel!
//business 3
    @IBOutlet weak var ratingThree: UIImageView!
    @IBOutlet weak var imageThree: UIImageView!
    @IBOutlet weak var businessThree: UILabel!
    @IBOutlet weak var distanceThree: UILabel!
    @IBOutlet weak var businessViewThree: UIView!
    
//business 2
    @IBOutlet weak var ratingTwo: UIImageView!
    @IBOutlet weak var distanceTwo: UILabel!
    @IBOutlet weak var businessTwo: UILabel!
    @IBOutlet weak var imageTwo: UIImageView!
    @IBOutlet weak var businessViewTwo: UIView!
    
//business 1
    @IBOutlet weak var businessViewOne: UIView!
    @IBOutlet weak var ratingOne: UIImageView!
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var distanceOne: UILabel!
    @IBOutlet weak var businessOne: UILabel!
    
    
    
    @IBOutlet weak var saveFavorites: UIButton!
    
    @IBOutlet weak var yelpScrollView: UIScrollView!
    
    var businesses: [Business]!
    var businessNames = [String]()
    var businessRatingImage = [String]()
    var businessPic = [String]()
    var businessDistance = [String]()
    
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationAddress: UILabel!
    @IBOutlet weak var locationType: UILabel!
    @IBOutlet weak var zipCode: UILabel!
    @IBOutlet weak var saveFavoriteButton: UIButton!
    
    var locationToPresent: [String : AnyObject] = [:]

    
    var favoriteToPresent: Location? = nil
    

    let dataStore = DataStore.store
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        yelpScrollView.contentSize.width = 1400
        self.yelpScrollView.backgroundColor = UIColor.init(red: 125.0/255, green: 181.0/255, blue: 107.0/255, alpha: 100.0)

        
        self.view.backgroundColor = UIColor.init(red: 125.0/255, green: 181.0/255, blue: 107.0/255, alpha: 100.0)
        
        if let favorite = self.favoriteToPresent {
            
            self.locationName.text = favorite.name
            self.locationAddress.text = favorite.address
            self.zipCode.text = favorite.zip
            self.locationType.text = favorite.type
            self.saveFavoriteButton.hidden = true
            
        } else {


        locationName.text =  locationToPresent["name"] as! String
        locationAddress.text =  locationToPresent["address"] as! String

        var type = locationToPresent["type"] as! String

        
        //to replace after kens icons populate tableview
        if type.containsString("Garden") {
            type = type + " 🌿"
        }

        locationType.text = type
        zipCode.text =  locationToPresent["zip"] as! String
        

        //print("Addresses of parks: \(locationAddress.text)")
        //print(locationToPresent)


        Business.searchWithTerm("healthy", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                
                //print(business.name!)
                
                self.businessRatingImage.append(String(business.ratingImageURL!))
                self.businessNames.append(business.name!)
                self.businessPic.append(String(business.imageURL!))
                self.businessDistance.append(String(business.distance!))
            }
        //Business 1
            self.businessOne.text = self.businessNames[0]
            self.distanceOne.text = self.businessDistance[0]
            
            let imageURLOne = NSURL(string: self.businessPic[0])
            let imageDataOne = NSData(contentsOfURL: imageURLOne!)
            if imageDataOne != nil {
                self.imageOne.image = UIImage(data: imageDataOne!)
            self.imageOne.layer.cornerRadius = 11
            self.imageOne.clipsToBounds = true

            self.businessViewOne.layer.cornerRadius = 11
            self.businessViewOne.clipsToBounds = true
            

            }
            
            let ratingURLOne = NSURL(string: self.businessRatingImage[0])
                        let ratingDataOne = NSData(contentsOfURL: ratingURLOne!)
                        if ratingDataOne != nil {
                                self.ratingOne.image = UIImage(data: ratingDataOne!)
                        }

            
        //business 2
            self.businessTwo.text = self.businessNames[1]
            self.distanceTwo.text = self.businessDistance[1]
            
            let imageURLTwo = NSURL(string: self.businessPic[1])
            let imageDataTwo = NSData(contentsOfURL: imageURLTwo!)
            if imageDataTwo != nil {
                self.imageTwo.image = UIImage(data: imageDataTwo!)
                self.imageTwo.layer.cornerRadius = 11
                self.imageTwo.clipsToBounds = true
                
                self.businessViewTwo.layer.cornerRadius = 11
                self.businessViewTwo.clipsToBounds = true
                
            }
            
            let ratingURLTwo = NSURL(string: self.businessRatingImage[1])
            let ratingDataTwo = NSData(contentsOfURL: ratingURLTwo!)
            if ratingDataTwo != nil {
                self.ratingTwo.image = UIImage(data: ratingDataTwo!)
            }

        //business 3
            
            self.businessThree.text = self.businessNames[2]
            self.distanceThree.text = self.businessDistance[2]
            
            let imageURLThree = NSURL(string: self.businessPic[2])
            let imageDataThree = NSData(contentsOfURL: imageURLThree!)
            if imageDataThree != nil {
                self.imageThree.image = UIImage(data: imageDataThree!)
                self.imageThree.layer.cornerRadius = 11
                self.imageThree.clipsToBounds = true
                
                self.businessViewThree.layer.cornerRadius = 11
                self.businessViewThree.clipsToBounds = true
                
            }
            
            let ratingURLThree = NSURL(string: self.businessRatingImage[2])
            let ratingDataThree = NSData(contentsOfURL: ratingURLThree!)
            if ratingDataThree != nil {
                self.ratingThree.image = UIImage(data: ratingDataThree!)
            }
            
        //business 4
            
            self.businessFour.text = self.businessNames[3]
            self.distanceFour.text = self.businessDistance[3]
            
            let imageURLFour = NSURL(string: self.businessPic[3])
            let imageDataFour = NSData(contentsOfURL: imageURLFour!)
            if imageDataFour != nil {
                self.imageFour.image = UIImage(data: imageDataFour!)
                self.imageFour.layer.cornerRadius = 11
                self.imageFour.clipsToBounds = true
                
                self.businessViewFour.layer.cornerRadius = 11
                self.businessViewFour.clipsToBounds = true
                
            }
            
            let ratingURLFour = NSURL(string: self.businessRatingImage[3])
            let ratingDataFour = NSData(contentsOfURL: ratingURLFour!)
            if ratingDataFour != nil {
                self.ratingFour.image = UIImage(data: ratingDataFour!)
            }

        //business 5
            self.businessFive.text = self.businessNames[4]
            self.distanceFive.text = self.businessDistance[4]
            
            let imageURLFive = NSURL(string: self.businessPic[4])
            let imageDataFive = NSData(contentsOfURL: imageURLFive!)
            if imageDataFive != nil {
                self.imageFive.image = UIImage(data: imageDataFive!)
                self.imageFive.layer.cornerRadius = 11
                self.imageFive.clipsToBounds = true
                
                self.businessViewFive.layer.cornerRadius = 11
                self.businessViewFive.clipsToBounds = true
                
            }
            
            let ratingURLFive = NSURL(string: self.businessRatingImage[4])
            let ratingDataFive = NSData(contentsOfURL: ratingURLFive!)
            if ratingDataFive != nil {
                self.ratingFive.image = UIImage(data: ratingDataFive!)
            }
            
        //business 6
            
            self.businessSix.text = self.businessNames[5]
            self.distanceSix.text = self.businessDistance[5]
            
            let imageURLSix = NSURL(string: self.businessPic[5])
            let imageDataSix = NSData(contentsOfURL: imageURLSix!)
            if imageDataSix != nil {
                self.imageSix.image = UIImage(data: imageDataSix!)
                self.imageSix.layer.cornerRadius = 11
                self.imageSix.clipsToBounds = true
                
                self.businessViewSix.layer.cornerRadius = 11
                self.businessViewSix.clipsToBounds = true
                
            }
            
            let ratingURLSix = NSURL(string: self.businessRatingImage[5])
            let ratingDataSix = NSData(contentsOfURL: ratingURLSix!)
            if ratingDataSix != nil {
                self.ratingSix.image = UIImage(data: ratingDataSix!)
            }
            
            })
        saveFavorites.layer.cornerRadius = 10
        saveFavorites.clipsToBounds = true
        
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func phoneNumber(sender: AnyObject) {
        let url: NSURL = NSURL(string: "tel://3472321892")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func saveToFavoritesTapped(sender: AnyObject) {
        
        let newFavorite = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: dataStore.managedObjectContext) as! Location
        
        newFavorite.name = (locationToPresent["name"] as! String)
        newFavorite.address = (locationToPresent["address"] as! String)
        
        if let type = locationToPresent["type"] {
            newFavorite.type = (type as! String)
        }
        
        if let zip = locationToPresent["zip"] {
            newFavorite.zip = (zip as! String)
        }
        
        if let waterfront = locationToPresent["waterfront"] {
            newFavorite.waterfront = (waterfront as! String)
        }
        
        if let hours = locationToPresent["hours"] {
            newFavorite.hours = (hours as! String)
        }
        
        newFavorite.user = dataStore.user[0]
        
        dataStore.saveContext()
        dataStore.fetchData()
        
    }
}
