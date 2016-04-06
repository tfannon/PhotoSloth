//
//  AssetCollectionVM.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 3/25/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

class AssetCollectionVM {

    private var assetResults : Results<SLAsset>
    private var token : NotificationToken?
    private var onModified : (() -> ())?
    private var onError : ((NSError) -> ())?

    // for RxSwift
    private let disposeBag = DisposeBag()
    
    init(onModified: (() -> ())? = nil, onError: ((NSError) -> ())? = nil) {
        
        // setup the results to be stored by date and id descending
        assetResults = slothRealm.getAssets()
            .filter("\(SLAsset.Properties.externalId) != nil")
            .sorted(SLAsset.Properties.dateTaken, ascending: false)
            .sorted(SLAsset.Properties.id, ascending: false)

        token = assetResults.addNotificationBlock{ results, error in
            if let e = error {
                self.onError?(e)
            }
            else {
                self.onModified?()
            }
        }
    }
    
    var count : Int {
        get {
            return assetResults.count
        }
    }
    
    func getId(index : Int) -> String {
        return assetResults[index].id
    }
    
    func getExternalId(index : Int) -> String {
        return assetResults[index].externalId ?? ""
    }
}