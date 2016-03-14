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
    var location = BehaviorSubject<String>(value: "")
    var isLiked = BehaviorSubject<Bool>(value: false)
    var image = BehaviorSubject<UIImage?>(value: nil)
    var poi = BehaviorSubject<String>(value: "")
    let disposeBag = DisposeBag()

    private var asset : SLAsset!
    
    init(assetId : String) {
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
            
//            asset.rx_observe(Bool.self, SLAsset.Properties.isLiked.rawValue)
//                .subscribeNext { value in
//                    self.isLiked.onNext(value!)
//                }.addDisposableTo(disposeBag)
//            asset.rx_observe(String.self, SLAsset.Properties.chosenPOI.rawValue)
//                .subscribeNext { value in
//                    self.poi.onNext(value ?? "")
//                }.addDisposableTo(disposeBag)
        }
        else {
            clear()
        }
    }
    
    func setImage(image : UIImage?) {
        self.image.onNext(image)
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