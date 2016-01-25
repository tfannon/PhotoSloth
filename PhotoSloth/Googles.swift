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
//import GoogleMaps

class Googles {

    static var IOSKEY: String = "AIzaSyBkTQikOVA5PLkmBf1SGbrvwOQIgL-vbbA"
    static var BROWSER_KEY = "AIzaSyAencAZogMezvzaufB5c2Nf7wqXXrKdFn8"
    
    class func getLocationTags(latitude: Double = 29.879500, longitude: Double = -81.287000, completion:(result: TagObject)->()) {
        let testUrl = ("https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&sensor=true")
        print (testUrl)
        Alamofire.request(.GET, testUrl, parameters: nil)
            .responseJSON { response in
                /*
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                */
                let tagObject = TagObject()
                if let value = response.result.value {
                    let json = JSON(value)
                    print (json)
                    let first = json["results"][0]["address_components"]
                    for (_,subJson) in first {
                        //city
                        var type = subJson["types"].array?.filter { $0 == "locality" }
                        if type?.count > 0 {
                            tagObject.city = subJson["short_name"].string
                        }
                        //state
                        type = subJson["types"].array?.filter { $0 == "administrative_area_level_1" }
                        if type?.count > 0 {
                            tagObject.state = subJson["short_name"].string
                        }
                        //state
                        type = subJson["types"].array?.filter { $0 == "country" }
                        if type?.count > 0 {
                            tagObject.country = subJson["short_name"].string
                        }
                        type = subJson["types"].array?.filter { $0 == "postal_code" }
                        if type?.count > 0 {
                            tagObject.zipCode = subJson["short_name"].string
                        }
                        completion(result:tagObject)
                    }
                }
        }
    }
    
    //29.879500,-81.287000  - Anastasia Fitness
    class func getPlaces(latitude: Double = 29.879500, longitude: Double = -81.287000, tagObject: TagObject, completion:(result: TagObject)->()) {
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
                    //print (json)
                    for (_,subJson) in json {
                        if let name = subJson["name"].string {
                            //print (name)
                            tagObject.places.append(name)
                        }
                    }
                    completion(result:tagObject)
                }
        }
    }
}