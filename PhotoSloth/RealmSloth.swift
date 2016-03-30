//
//  SlothRealm.swift
//  PhotoDeclutter_1
//
//  Created by Adam Rothberg on 1/23/16.
//  Copyright © 2016 Adam Rothberg. All rights reserved.
//

import Foundation
import RealmSwift

class RealmSloth : RealmBase {

    // MARK:- Tag
    
    // returns a Tag object given the tag string value
    func getTag(value: String) -> SLTag? {
        return self.select(SLTag).filter("value = '\(value)'").first
    }
    
    // adds a tag to an asset
    // this is particularily useful because we want to reuse a Tag 
    //  object that is already in the database.  So we first lookup the Tag
    //  on the tagValue and use it, otherwise we create a new Tag
    func addTag(asset : SLAsset, tagValue : String) {
        var write = false
        var tag = getTag(tagValue)
        if tag != nil {
            write = !asset.tags.contains(tag!)
        }
        else {
            tag = SLTag(string: tagValue)
            write = true
        }
        if write {
            let writeToTag = !tag!.assets.contains(asset)
            self.write {
                asset.tags.append(tag!)
                if writeToTag {
                    tag!.assets.append(asset)
                }
            }
        }
    }
    
    // MARK:- Asset
    
    // returns an Asset given the id
    func getAsset(id id: String) -> SLAsset? {
        return self.get(id)
    }
    // returns an Asset given the external id
    func getAsset(externalId id : String) -> SLAsset? {
        return self.select(SLAsset).filter("externalId = '\(id)'").first
    }
    // returns all Assets
    func getAssets() -> Results<SLAsset> {
        return self.select(SLAsset.self)
    }
    // adds an Asset with optional Tags
    func addAsset(asset : SLAsset, tagValues : String...) {
        self.write {
            self.add(asset)
        }
        // enumerate all tags and add them to the asset
        for tagValue in tagValues {
            addTag(asset, tagValue: tagValue)
        }
    }
}