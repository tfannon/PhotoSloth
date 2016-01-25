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
        Async.background {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let fetchResult = PHAsset.fetchAssetsWithOptions(options)
            for i in 0..<fetchResult.count {
                
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
                            var assetForLocationUpdate = asset
                            if let id = newAssetId {
                                assetForLocationUpdate = slothRealm.getAsset(id)
                            }
                            if let a = assetForLocationUpdate {
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
                }
//                if !asset.isPotentialPOIsSet {
//                    if let coordinates = photoAsset.location?.coordinate {
//                        Googles.getPlaces(coordinates.latitude, longitude: coordinates.longitude) {
//                            tagObject in
//                            if tagObject.places.count > 1 {
//                                slothRealm.write {
//                                    asset.potentialPOIs = tagObject.places
//                                    asset.isPotentialPOIsSet = true }
//                            }
//                        }
//                    }
//                } else {
//                    print (asset.potentialPOIs)
//                }
            }
        }.main {
            completion?()
        }
    }
}