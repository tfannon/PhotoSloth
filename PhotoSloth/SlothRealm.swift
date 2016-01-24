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
    func getTag(value: String) -> Tag? {
        return self.select(Tag).filter("value = '\(value)'").first
    }
    func getMemory(id: String) -> Memory? {
        return self.getBaseObjectId(id)
    }
    func addTagToMemory(memory : Memory, tagValue : String) {
        var write = false
        var tag = getTag(tagValue)
        if tag != nil {
            write = !memory.tags.contains(tag!)
        }
        else {
            tag = Tag(string: tagValue)
            write = true
        }
        if write {
            let writeToTag = !tag!.memories.contains(memory)
            self.write {
                memory.tags.append(tag!)
                if writeToTag {
                    tag!.memories.append(memory)
                }
            }
        }
    }
    func addMemory(memory : Memory, tagValues : String...) {
        self.write {
            self.add(memory)
        }
        for tagValue in tagValues {
            addTagToMemory(memory, tagValue: tagValue)
        }
    }
}