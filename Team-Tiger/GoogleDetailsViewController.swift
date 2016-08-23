//
//  GoogleDetailsViewController.swift
//
//
//  Created by Laticia Chance on 8/17/16.
//
//

import UIKit
//import Alamofire
//import SwiftyJSON


class GoogleDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var locaionName: UILabel!
    @IBOutlet weak var locationAddress: UILabel!
    @IBOutlet weak var locationRating: UILabel!
    
    var latitude = String()
    var longitude = String()
    var googleSearchResults: [String: String] = [:]
    
    var locationFromDetailView = detailViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func parseCoordinates(rawCoordinates: String) -> (String, String)? {
        
        let parseCoordinatesFirstPass = rawCoordinates.componentsSeparatedByString(">").first
        let parseCoordinatesSecondPass = parseCoordinatesFirstPass?.componentsSeparatedByString("<").last
        let finalCoordinates = parseCoordinatesSecondPass?.componentsSeparatedByString(",")
        
        //        let finalCoordinatesForFM = String(locationsFromDataStore.farmersMarketArray[0]["coordinates"])
        //        let finalCoordinatesFirstPassFM = finalCoordinatesForFM.componentsSeparatedByString(">").first
        //        let finalCoordinatesSecondPassFM = finalCoordinatesFirstPassFM?.componentsSeparatedByString("<").last
        //        let farmersMarketCoordinates = finalCoordinatesSecondPassFM?.componentsSeparatedByString(",")
        //
        //        let finalCoordinatesForGardens = String(locationsFromDataStore.greenThumbArray[0]["coordinates"])
        //        let finalCoordinatesFirstPassGardens = finalCoordinatesForGardens.componentsSeparatedByString(">").first
        //        let finalCoordinatesSecondPassGardens = finalCoordinatesFirstPassGardens?.componentsSeparatedByString("<").last
        //        let gardenCoordinates = finalCoordinatesSecondPassGardens?.componentsSeparatedByString(",")
        
        
        //should probably unwrap these appropiately//also may have to specify that this is the PARKS lat/long
        latitude = finalCoordinates![0]
        longitude = finalCoordinates![1]
        
        let coordinates = (latitude,longitude)
        return coordinates
    }
    
    func getGoogleSearchPlaceIDFrom(coordinates: (String, String), completionHandler: (String?) -> ()) {
        
        Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=500&type=restaurant&name=cruise&key=AIzaSyBL-Opv8MzHLhMcQ241dZBWYtanPhqfSHQ").responseJSON {response in
            
            guard let jsonData = response.data else {return}
            let jsonObject = JSON(data: jsonData)
            let placeID = jsonObject["results"][1]["place_id"].string!
            
            
            // Add results to dictionary
            self.googleSearchResults["place_id"] = placeID
            
            guard let rating = jsonObject["results"][0]["rating"].double else {return}
            
            
            completionHandler(placeID)
        }
        
    }
    
    func getGooglePlaceDetailsFrom(placeID id: String, completionHandler: [String: String]? -> ()){
        
        Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(id)&key=AIzaSyBkEKRXCtoXZThYqylgUrHKGkjAmJ_1mSM").responseJSON {response in
            let checkingOutTheResponse = response.result.value
            print(checkingOutTheResponse)
            
            
            guard let rawData = response.data else {return}
            
            let jsonObject = JSON(data: rawData)
            print(jsonObject)
            
            let phoneNumber = jsonObject["result"]["formatted_phone_number"].stringValue
            
            //let ratings = jsonObject["result"]["rating"].doubleValue
            //print("Rating: \(ratings)")
            
            let openingHours = jsonObject["result"]["opening_hours"]["weekday_text"].arrayValue
            
            let address = jsonObject["result"]["formatted_address"].stringValue
            
            
        }
    }
}
//        googleSearchTest { results in
//
//            guard let placeID = results["place_id"] else {return}
//            print("\n\n\nplace id returned from results: \(placeID)\n\n\n")
//            self.googlePlaceDetails(placeID, completion: { (latitude, longitude) in
//
//
//            })
//        }
//    }
//
//
//    // call api in datat
//    func googleSearchTest(completionHandler: ([String: String]) -> ()) {
//
//
//        Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=500&type=restaurant&name=cruise&key=AIzaSyBL-Opv8MzHLhMcQ241dZBWYtanPhqfSHQ").responseJSON {response in
//
//            // let dataFromSearch = response.result.value
//
//            guard let jsonData = response.data else {return}
//
//            let jsonObject = JSON(data: jsonData)
//
//
//            let name = jsonObject["results"][0]["name"].string!
//
//            // Get place id
//            let placeID = jsonObject["results"][1]["place_id"].string!
//            //print("PLACE ID!!::: \(placeID)")
//
//            // Get rating
//            guard let rating = jsonObject["results"][0]["rating"].double else {return}
//
//            // Get open status
//            let openNow = jsonObject["results"][1]["opening_hours"]["open_now"].stringValue
//            //print(openNow)
//
//            // Add results to dictionary
//            self.googleSearchResults["place_id"] = placeID
//            self.googleSearchResults["rating"] = String(rating)
//            self.googleSearchResults["open_status"] = openNow
//            self.googleSearchResults["name"] = name
//
//            completionHandler(self.googleSearchResults)
//
//        }
//    }
//

//    func getLatitudeAndLongitude(typeOfLocation: [String: AnyObject]) -> (String, String) {
//
//        if typeOfLocation {
//
//        let closestCoordinate = String(locationFromDetailView.locationToPresent["Closest Coordinate"])
//        let parseCoordinatesFirstPass = closestCoordinate.componentsSeparatedByString(">").first
//        let parseCoordinatesSecondPass = parseCoordinatesFirstPass?.componentsSeparatedByString("<").last
//        let parkCoordinates = parseCoordinatesSecondPass?.componentsSeparatedByString(",")
//
//        //should probably unwrap these appropiately//also may have to specify that this is the PARKS lat/long
//        latitude = parkCoordinates![0]
//        longitude = parkCoordinates![1]
//
//        let coordinates = (latitude,longitude)
//        return coordinates
//        }
//
//
//        let finalCoordinatesForFM = String(locationsFromDataStore.farmersMarketArray[0]["coordinates"])
//        let finalCoordinatesFirstPassFM = finalCoordinatesForFM.componentsSeparatedByString(">").first
//        let finalCoordinatesSecondPassFM = finalCoordinatesFirstPassFM?.componentsSeparatedByString("<").last
//        let farmersMarketCoordinates = finalCoordinatesSecondPassFM?.componentsSeparatedByString(",")
//
//        let finalCoordinatesForGardens = String(locationsFromDataStore.greenThumbArray[0]["coordinates"])
//        let finalCoordinatesFirstPassGardens = finalCoordinatesForGardens.componentsSeparatedByString(">").first
//        let finalCoordinatesSecondPassGardens = finalCoordinatesFirstPassGardens?.componentsSeparatedByString("<").last
//        let gardenCoordinates = finalCoordinatesSecondPassGardens?.componentsSeparatedByString(",")
//
//
//    }

//    func googlePlaceDetails(place_ID: String, completion: (String, String ) -> ()){
//
//        Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(place_ID)&key=AIzaSyBkEKRXCtoXZThYqylgUrHKGkjAmJ_1mSM").responseJSON {response in
//            let checkingOutTheResponse = response.result.value
//            print(checkingOutTheResponse)
//
//
//            guard let rawData = response.data else {return}
//
//            let jsonObject = JSON(data: rawData)
//            print(jsonObject)
//
//            let phoneNumber = jsonObject["result"]["formatted_phone_number"].stringValue
//
//            //let ratings = jsonObject["result"]["rating"].doubleValue
//            //print("Rating: \(ratings)")
//
//            let openingHours = jsonObject["result"]["opening_hours"]["weekday_text"].arrayValue
//
//            let address = jsonObject["result"]["formatted_address"].stringValue
//
//            completion(self.latitude, self.longitude)
//        }
//    }
//}
