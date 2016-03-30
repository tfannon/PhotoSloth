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

    private var results : Results<SLAsset>
    private var token : NotificationToken?
    
    init(assetId : String) {
        results = slothRealm.getAssets()
        token = nil
    }
}