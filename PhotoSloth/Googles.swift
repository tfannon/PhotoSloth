//
//  Googles.swift
//  PhotoSloth
//
//  Created by Tommy Fannon on 1/23/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//7

import Foundation
import Alamofire
import SwiftyJSON
import GoogleMaps

class Googles {

    static var IOSKEY: String = "AIzaSyBkTQikOVA5PLkmBf1SGbrvwOQIgL-vbbA"
    static var BROWSER_KEY = "AIzaSyAencAZogMezvzaufB5c2Nf7wqXXrKdFn8"
    
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
    
    //29.879500,-81.287000  - Anastasia Fitness
    class func getPlaces(latitude: Double = 29.879500, longitude: Double = -81.287000, completion:(tags: [String])->()) {
        let testUrl = ("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=200&key=\(BROWSER_KEY)")
        Alamofire.request(.GET, testUrl, parameters: nil)
            .responseJSON { response in
                /*
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                */
                if let value = response.result.value {
                    let json = JSON(value)["results"]
                    var tags = [String]()
                    //print (json)
                    for (_,subJson) in json {
                        if let name = subJson["name"].string {
                            //print (name)
                            tags.append(name)
                        }
                    }
                    completion(tags: tags)
                }
        }
    }
}