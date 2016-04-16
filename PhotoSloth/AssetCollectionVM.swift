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

    // the results of the asset query
    private var assetResults : Results<SLAsset>
    private var token : NotificationToken?
    private var onModified : (() -> ())?
    private var onError : ((NSError) -> ())?

    // for RxSwift
    private let disposeBag = DisposeBag()
    
    // 
    // onModified - what to call when the data is modified
    // onError - what to call on an error
    //
    init(onModified: (() -> ())? = nil, onError: ((NSError) -> ())? = nil) {
        
        // setup the results to be stored by date and id descending
        assetResults = slothRealm.getAssets()
            .filter("\(SLAsset.Properties.externalId) != nil")
            .sorted(SLAsset.Properties.dateTaken, ascending: false)
            .sorted(SLAsset.Properties.id, ascending: false)

        // token to notify us when changes occur
        token = assetResults.addNotificationBlock{ results, error in
            if let e = error {
                self.onError?(e)
            }
            else {
                self.onModified?()
            }
        }
    }
    
    // count of assets
    var count : Int {
        get {
            return assetResults.count
        }
    }
    
    //
    // return the Id of the asset based on the ordinal index
    //
    func getId(index : Int) -> String {
        return assetResults[index].id
    }
    
    //
    // get the photo size for the UI from the ordinal index
    //
    func getPhotoAssetSize(index : Int) -> CGSize {
        let photoAssetSize = PhotoAssetService.getSize(assetResults[index].externalId!)
        return photoAssetSize
    }
}