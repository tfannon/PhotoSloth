//
//  PhotoCollectionVM.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 3/25/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

class PhotoCollectionVM {

    private var assetResults : Results<SLAsset>
    private var token : NotificationToken?
    var onModified : (() -> ())?
    var onError : ((NSError) -> ())?
    
    init() {
        assetResults = slothRealm.getAssets()
        token = assetResults.addNotificationBlock{ results, error in
            self.onModified?()
            if let e = error {
                self.onError?(e)
            }
        }
    }
    
    
}