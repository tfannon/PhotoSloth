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
    var poi = BehaviorSubject<String>(value: "")
    let disposeBag = DisposeBag()

    private var asset : SLAsset!
    
    init(assetId : String, imageSize : CGSize) {
        if let a = slothRealm.getAsset(id: assetId) {
            self.asset = a
            self.caption.onNext(self.asset.caption)
            self.location.onNext(self.asset.locationText)
            self.isLiked.onNext(self.asset.isLiked)
            self.isLiked.subscribeNext { value in
                slothRealm.write {
                    self.asset.isLiked = value
                }
            }.addDisposableTo(disposeBag)
            self.poi.onNext(self.asset.chosenPOI ?? "")

            // start loading the image
            if let externalId = self.asset.externalId {
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
    
    func toggleLiked() {
        self.isLiked.onNext(!self.asset.isLiked)
    }
    
    private func clear() {
        self.caption.onNext("")
        self.location.onNext("")
        self.isLiked.onNext(false)
        self.poi.onNext("")
        self.image.onNext(nil)
    }
}