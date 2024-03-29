//
//  AssetGatherer.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 1/25/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation
import RealmSwift
import Photos
import Async

class AssetGatherer {
    
    // queries the device's photo assets (PHPhotoAsset)
    // and populates the SLAssets
    static func gather(
        progress : ((Progress) -> Void)? = nil,
        completion : (() -> Void)? = nil) {
        Async.background {
            // delay for testing
            if let delay = UserSettings.delayGather {
                sleep(UInt32(delay))
            }
            
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let fetchResult = PHAsset.fetchAssetsWithOptions(options)
            for i in 0..<fetchResult.count {
                
                // delay for testing
                if let delay = UserSettings.delayGatherBetween {
                    sleep(UInt32(delay))
                }
                
                // progress callback
                progress?(Progress(current: i+1, total: fetchResult.count))
                
                // get the photoAsset and
                // get or create a new SLAsset's
                let photoAsset: PHAsset = fetchResult[i] as! PHAsset
                var asset: SLAsset!
                var newAssetId: String? = nil
                asset = nil //slothRealm.getAsset(externalId: photoAsset.localIdentifier)
                if asset == nil {
                    asset = SLAsset()
                    asset.longitude = photoAsset.location?.coordinate.longitude ?? 0
                    asset.latitude = photoAsset.location?.coordinate.longitude ?? 0
                    asset.dateTaken = photoAsset.creationDate
                    asset.externalId = photoAsset.localIdentifier
                    newAssetId = asset.id
                    slothRealm.addAsset(asset)
                }
                
                if !asset.isLocationSet {
                    if let coordinates = photoAsset.location?.coordinate {
                        LocationService.getLocationTags(coordinates.latitude, longitude: coordinates.longitude) { tagObject in
                            // if the asset was created on the other thread - we need our own
                            var assetForUpdate = asset
                            if let id = newAssetId {
                                assetForUpdate = slothRealm.getAsset(id: id)
                            }
                            if let a = assetForUpdate {
                                slothRealm.write {
                                    a.country = tagObject.country
                                    a.city = tagObject.city
                                    a.state = tagObject.state
                                    a.postalCode = tagObject.zipCode
                                    a.isLocationSet = true
                                }
                            }
                        }
                    }
                } else {
                    print ("\(asset.id) city: \(asset.city != nil ? asset.city! : "no city data") ")
                }
                
                if !asset.isPotentialPOISet {
                    if let coordinates = photoAsset.location?.coordinate {
                        LocationService.getPlaces(coordinates.latitude, longitude: coordinates.longitude) { tagObject in
                            var assetForUpdate = asset
                            if let id = newAssetId {
                                assetForUpdate = slothRealm.getAsset(id: id)
                            }
                            if let a = assetForUpdate {
                                slothRealm.write {
                                    a.potentialPOIs = tagObject.places
                                    a.isPotentialPOISet = true
                                }
                            }
                        }
                    }
                } else {
                    print ("\(asset.id) poi: \(asset.potentialPOIs.any ? asset.potentialPOIs : ["no poi data"])")
                }
            }
            }.main {
                completion?()
        }
    }
}