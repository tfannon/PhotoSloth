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
    
    static func completed(block : () -> Void) -> AssetGatherer {
        return AssetGatherer()
    }
    static func progress(block : () -> Progress) -> AssetGatherer {
        return AssetGatherer()
    }
    
    // queries the device's photo assets (PHPhotoAsset)
    // and populates the SLAssets
    static func gather(
        progress : ((Progress) -> Void)? = nil,
        completion : (() -> Void)? = nil) {
            
            // progress 0
            progress?(Progress())

            let f : () -> Void = {
                gatherImpl(progress, completion : completion)
            }
            
            if let delay = UserSettings.delayGather {
                NSTimer.schedule(delay: Double(delay)) { _ in
                    f()
                }
            }
            else {
                f()
            }
    }
    
    private static func gatherImpl(
        progress : ((Progress) -> Void)? = nil,
        completion : (() -> Void)? = nil) {
        Async.background {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let fetchResult = PHAsset.fetchAssetsWithOptions(options)
            for i in 0..<fetchResult.count {
                
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
                asset = slothRealm.getAssetByExternalId(photoAsset.localIdentifier)
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
                        Googles.getLocationTags(coordinates.latitude, longitude: coordinates.longitude) { tagObject in
                            // if the asset was created on the other thread - we need our own
                            var assetForUpdate = asset
                            if let id = newAssetId {
                                assetForUpdate = slothRealm.getAsset(id)
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
                        Googles.getPlaces(coordinates.latitude, longitude: coordinates.longitude) { tagObject in
                            var assetForUpdate = asset
                            if let id = newAssetId {
                                assetForUpdate = slothRealm.getAsset(id)
                            }
                            if let a = assetForUpdate {
                                slothRealm.write {
                                    a.potentialPOI = tagObject.places
                                    a.isPotentialPOISet = true
                                }
                            }
                        }
                    }
                } else {
                    print ("\(asset.id) poi: \(asset.potentialPOI.any ? asset.potentialPOI : ["no poi data"])")
                }
            }
            }.main {
                completion?()
        }
    }
}