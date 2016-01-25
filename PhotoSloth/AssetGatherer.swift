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

class AssetGatherer {
    
    // queries the device's photo assets (PHPhotoAsset)
    // and populates the SLAssets
    static func gather() {
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssetsWithOptions(options)

        for i in 0..<fetchResult.count {
            let photoAsset: PHAsset = fetchResult[i] as! PHAsset
            var asset: SLAsset!
            asset = slothRealm.getAssetByExternalId(photoAsset.localIdentifier)
            if asset == nil {
                asset = SLAsset()
                asset.longitude = photoAsset.location?.coordinate.longitude ?? 0
                asset.latitude = photoAsset.location?.coordinate.longitude ?? 0
                asset.dateTaken = photoAsset.creationDate
                asset.externalId = photoAsset.localIdentifier
                slothRealm.addAsset(asset)
            }
            if !asset.isLocationSet {
                if let coordinates = photoAsset.location?.coordinate {
                    Googles.getLocationTags(coordinates.latitude, longitude: coordinates.longitude) { tagObject in
                        slothRealm.write {
                            asset.country = tagObject.country
                            asset.city = tagObject.city
                            asset.state = tagObject.state
                            asset.postalCode = tagObject.zipCode
                            asset.isLocationSet = true
                        }
                    }
                }
            }
        }
    }
}