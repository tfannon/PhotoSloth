//
//  PhotoCellVM.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 3/12/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation
import RxSwift
import Async

class PhotoCellVM {
    
    var caption = BehaviorSubject<String>(value: "")
    var comments = BehaviorSubject<String>(value: "")
    var isLiked = BehaviorSubject<Bool>(value: false)
    var image = BehaviorSubject<UIImage?>(value: nil)
    var poi = BehaviorSubject<String>(value: "")
    let disposeBag = DisposeBag()

    private var asset : SLAsset!
    
    init(assetId : String) {
        self.asset = slothRealm.getAsset(id: assetId)
        self.caption.onNext(self.asset.caption)
        self.comments.onNext(self.asset.locationText)
        self.isLiked.onNext(self.asset.isLiked)
        self.isLiked.subscribeNext { value in
            slothRealm.write {
                self.asset.isLiked = value
            }
        }.addDisposableTo(disposeBag)
        self.poi.onNext(self.asset.chosenPOI ?? "")
    }
    
    func setImage(image : UIImage?) {
        self.image.onNext(image)
    }
    
    func toggleLiked() {
        self.isLiked.onNext(!self.asset.isLiked)
    }
}