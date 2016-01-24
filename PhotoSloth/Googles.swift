//
//  Googles.swift
//  PhotoSloth
//
//  Created by Tommy Fannon on 1/23/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import GoogleMaps

class Googles {

    static var APIKEY: String = "AIzaSyBkTQikOVA5PLkmBf1SGbrvwOQIgL-vbbA"
    
    class func getLocationTags(latitude: Double, longitude: Double, completion:(tags: [String])->()) {
        let testUrl = ("https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&sensor=true")
        Alamofire.request(.GET, testUrl, parameters: nil)
            .responseJSON { response in
                /*
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                */
                if let value = response.result.value {
                    let json = JSON(value)
                    let first = json["results"][0]["address_components"]
                    for (_,subJson) in first {
                        //print (index, subJson)
                        let type = subJson["types"].array?.filter { $0 == "locality" }
                        if type?.count > 0 {
                            let city = subJson["short_name"]
                            //print (city.string!)
                            completion(tags: [city.string!])
                        }
                    }
                }
        }
        //completion(tags: ["St.Augustine", "The Beach"])
    }
}