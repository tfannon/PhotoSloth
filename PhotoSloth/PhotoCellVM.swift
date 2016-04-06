//
//  PhotoCellVM.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 3/12/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation
import RxSwift

class PhotoCellVM {
    
    var caption = BehaviorSubject<String>(value: "")
    var location = BehaviorSubject<String>(value: "")
    var isLiked = BehaviorSubject<Bool>(value: false)
    var image = BehaviorSubject<UIImage?>(value: nil)
    var chosenPOI = BehaviorSubject<String>(value: "")
    var potentialPOIs : [String] {
        get {
            return asset.potentialPOIs
        }
        set {
            slothRealm.write {
                self.asset.potentialPOIs = newValue
            }
        }
    }
    let disposeBag = DisposeBag()

    private var asset : SLAsset!
    private var photoAssetRequest : PhotoAssetRequest?

    // 
    // initialize the view model with an asset id & image size
    // we wire up the BehaviorSubjects for two-way communication
    //  between UI and view model 
    //  and start loading the image from the PhotoAssetService
    //
    init(assetId : String, imageSize : CGSize) {
        if let a = slothRealm.getAsset(id: assetId) {
            self.asset = a
            self.caption.onNext(self.asset.caption)
            self.location.onNext(self.asset.locationText)
            self.isLiked.onNext(self.asset.isLiked)
            self.chosenPOI.onNext(self.asset.chosenPOI ?? "")
            
            if (!self.potentialPOIs.any) {
                self.potentialPOIs = ["Mercury", "Venus", "Mars"]
            }
            
            // whenever the image is set - nil out the request
            // the request is no longer needed once we've set the image to any new value
            self.image.subscribeNext { _ in
                self.photoAssetRequest = nil
            }.addDisposableTo(disposeBag)

            // whenever the UI clicks on the like button - write that to the db
            self.isLiked.subscribeNext { value in
                slothRealm.write {
                    self.asset.isLiked = value
                }
            }.addDisposableTo(disposeBag)

            // start loading the image
            // if you cannot load it - set it to nil
            if let externalId = self.asset.externalId {
                photoAssetRequest =
                    PhotoAssetService.requestImage(externalId, targetSize: imageSize) { image in
                        self.image.onNext(image)
                    }
            }
            else {
                self.image.onNext(nil)
            }
        }
        else {
            clear()
        }
    }
    
    private func clear() {
        if let r = photoAssetRequest {
            PhotoAssetService.cancelRequest(r)
        }
        self.caption.onNext("")
        self.location.onNext("")
        self.isLiked.onNext(false)
        self.chosenPOI.onNext("")
        self.image.onNext(nil)
    }
}