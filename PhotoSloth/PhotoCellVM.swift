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
    
    // not a subject since it's not visible all the time
    // and not bound to anything.
    // only when you display a list
    var potentialPOIs : [String] {
        get {
            return asset.potentialPOIs
        }
    }
    let disposeBag = DisposeBag()

    private var asset : SLAsset!
    // the async request for the photo - we can cancel it if we want to
    private var photoAssetRequest : PhotoAssetRequest?

    // 
    // initialize the view model with an asset id & image size
    //  we wire up the BehaviorSubjects for two-way communication
    //  between UI and view model 
    //  and start loading the image from the PhotoAssetService
    //
    init(assetId : String, imageSize : CGSize) {
        if let a = slothRealm.getAsset(id: assetId) {
            self.asset = a
            
            // push the current values onto the subjects
            // this will signal to the subscribers that the value has changed
            self.caption.onNext(self.asset.caption)
            self.location.onNext(self.asset.locationText)
            self.isLiked.onNext(self.asset.isLiked)
            self.chosenPOI.onNext(self.asset.chosenPOI ?? "")
            
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
            dispose()
        }
    }
    
    // when the cell is deallocated call clear
    deinit {
        dispose()
    }
    
    func dispose() {
        // cancel the request if we are done with the cell
        if let r = photoAssetRequest {
            PhotoAssetService.cancelRequest(r)
        }
        self.caption.dispose()
        self.location.dispose()
        self.isLiked.dispose()
        self.chosenPOI.dispose()
        self.image.dispose()
    }
}