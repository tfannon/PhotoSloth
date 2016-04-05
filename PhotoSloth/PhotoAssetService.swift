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
    
    class func requestImage(id : String, targetSize : CGSize, onComplete: (UIImage?) -> Void) -> PhotoAssetRequest {
        let photoAsset = getAsset(id)
        let requestId = imageManager.requestImageForAsset(photoAsset, targetSize: targetSize, contentMode: .AspectFill, options: nil) { image, _ in
                onComplete(image)
        }
        return PhotoAssetRequest(id: requestId)
    }
    
    class func cancelRequest(request : PhotoAssetRequest) {
        imageManager.cancelImageRequest(request.id)
    }
    
    class func getSize(id : String) -> CGSize {
        let asset = getAsset(id)
        return CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
    }
}

class PhotoAssetRequest {
    private(set) var id : PHImageRequestID
    init(id : PHImageRequestID) {
        self.id = id
    }
}
