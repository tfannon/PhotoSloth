//
//  Model.swift
//  PhotoDeclutter_1
//
//  Created by Adam Rothberg on 1/23/16.
//  Copyright © 2016 Adam Rothberg. All rights reserved.
//

import Foundation
import RealmSwift

enum MemoryStatus : Int {
    case None = 0
    case Liked = 1
    case Unliked = 2
}

// MARK: BaseObjects

//
// base object for all domain objects
//
class BaseObject : Object, Equatable {
    // returns true if the types are equal - this is a precondition that must be met for any subclass
    func equals<T where T: BaseObject>(other: T) -> Bool {
        return self.dynamicType.self === other.dynamicType.self
    }
}
func ==<T where T : BaseObject>(lhs : T, rhs : T) -> Bool { return lhs.equals(rhs) }

//
// base object for all domain objects with an Id
//
class BaseObjectId : BaseObject {
    static func Create<T : BaseObjectId>(type: T.Type, id : String) -> T {
        let object = T()
        object.id = id
        return object
    }
    convenience init(id : String) {
        self.init()
        self.id = id
    }
    dynamic var id : String! = NSUUID.newUUID()
    override static func primaryKey() -> String? {
        return "id"
    }
    override func equals<T where T : BaseObjectId>(other: T) -> Bool {
        return super.equals(other) && self.id == other.id
    }
}

// MARK: Memory

//
// a 'memory' - photo, video, etc...
//
class Memory : BaseObjectId {
    dynamic var title : String?
    dynamic var externalId : String? 
    dynamic var dateTaken : NSDate?
    
    // enums need to be persisted as Ints - so we do that privately while
    //  exposing the enum publically
    private dynamic var _status : Int = MemoryStatus.None.rawValue
    var status : MemoryStatus {
        get {
            return MemoryStatus(rawValue: _status)!
        }
        set {
            _status = newValue.rawValue
        }
    }
    
    let tags = List<Tag>()
    let events = List<Event>()
}

// MARK: Tags

class Tag : BaseObject {
    dynamic var value = ""
    let memories = List<Memory>()

    convenience init(string : String) {
        self.init()
        self.value = string
    }
    override static func primaryKey() -> String? {
        return "value"
    }
    override func equals<T where T : Tag>(other: T) -> Bool {
        return super.equals(other) && self.value.equalsCI(other.value)
    }
}

// MARK: Events

class Event : BaseObjectId {
    dynamic var title = ""
    dynamic var date : NSDate?
    let tags = List<Tag>()
}