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
    func getTag(value: String) -> SLTag? {
        return self.select(SLTag).filter("value = '\(value)'").first
    }
    func getAsset(id: String) -> SLAsset? {
        return self.getBaseObjectId(id)
    }
    func addTagToMemory(asset : SLAsset, tagValue : String) {
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
    func addMemory(asset : SLAsset, tagValues : String...) {
        self.write {
            self.add(asset)
        }
        for tagValue in tagValues {
            addTagToMemory(asset, tagValue: tagValue)
        }
    }
}