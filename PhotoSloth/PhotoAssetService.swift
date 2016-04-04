//
//  PhotoAssetService.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 4/3/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation
import Photos

class PhotoAssetService {
    
    class private var imageManager : PHCachingImageManager {
        get {
            return PHCachingImageManager()
        }
    }
    
    class private func getAsset(id : String) -> PHAsset {
        let fetchResult = PHAsset.fetchAssetsWithLocalIdentifiers([id], options: nil)
        let photoAsset = fetchResult[0] as! PHAsset
        return photoAsset
    }
    
    class func requestImage(id : String, targetSize : CGSize, onComplete: (UIImage?) -> Void) {
        let photoAsset = getAsset(id)
        imageManager.requestImageForAsset(photoAsset, targetSize: targetSize, contentMode: .AspectFill, options: nil) { image, _ in
                onComplete(image)
        }
    }
    
    class func getSize(id : String) -> CGSize {
        let asset = getAsset(id)
        return CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
    }
}