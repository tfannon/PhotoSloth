//
//  Model.swift
//  PhotoDeclutter_1
//
//  Created by Adam Rothberg on 1/23/16.
//  Copyright © 2016 Adam Rothberg. All rights reserved.
//

import Foundation
import RealmSwift

enum SLAssetStatus : Int {
    case None = 0
    case Liked = 1
    case Unliked = 2
}

// MARK: BaseObjects

//
// base object for all domain objects
//
class SLBaseObject : Object, Equatable {
    // returns true if the types are equal - this is a precondition that must be met for any subclass
    func equals<T where T: SLBaseObject>(other: T) -> Bool {
        return self.dynamicType.self === other.dynamicType.self
    }
    
    // useful for initializing and returning a collection of SLBaseObjects
    // we need a private List<T> member for Realm persistance, but for our API, it's nicer to work with Collection
    //  objects with append & remove methods w/o exposing the entire list object
    // so based on the passed in list type and keyed on name, we create an SLBaseObjectCollection object
    //  for the provided SLBaseObject type T.  May be bad for performance for lookup & casting every time - easy
    //  to switch out if we need to
    private var collections = [String : AnyObject]()
    func getCollection<T : SLBaseObject>(name : String, list : List<T>) -> SLBaseObjectCollection<T> {
        if let collection = collections[name] {
            return collection as! SLBaseObjectCollection<T>
        }
        else {
            let collection = SLBaseObjectCollection<T>(list: list)
            collections[name] = collection
            return collection
        }
    }
}
func ==<T where T : SLBaseObject>(lhs : T, rhs : T) -> Bool { return lhs.equals(rhs) }

//
// base object for all domain objects with an Id
//
class SLBaseObjectId : SLBaseObject {
    static func Create<T : SLBaseObjectId>(type: T.Type, id : String) -> T {
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
    override func equals<T where T : SLBaseObjectId>(other: T) -> Bool {
        return super.equals(other) && self.id == other.id
    }
}

//
// base collection type for all domain objects with an Id
//
class SLBaseObjectCollection<T : SLBaseObject> {
    var list : List<T>
    init(list : List<T>) {
        self.list = list
    }
    func append(item : T) {
        list.append(item)
    }
    func remove(item : T) -> Bool {
        if let index = getIndexOf(item) {
            list.removeAtIndex(index)
            return true
        }
        return false
    }
    func contains(item : T) -> Bool {
        return getIndexOf(item) != nil
    }
    
    // return the index in the collection that matches 'match'
    private func getIndexOf(match : T) -> Int? {
        for i in 0..<list.count {
            let currentItem = list[i]
            if currentItem.equals(match) {
                return i
            }
        }
        return nil
    }
}

// MARK: SLAsset

//
// an 'asset' - photo, video, etc...
//
typealias SLAssetCollection = SLBaseObjectCollection<SLAsset>
class SLAsset : SLBaseObjectId {
    dynamic var title : String?
    dynamic var externalId : String? 
    dynamic var dateTaken : NSDate?
    
    // enums need to be persisted as Ints - so we do that privately while
    //  exposing the enum publically
    private dynamic var _status : Int = SLAssetStatus.None.rawValue
    var status : SLAssetStatus {
        get {
            return SLAssetStatus(rawValue: _status)!
        }
        set {
            _status = newValue.rawValue
        }
    }
    
    private let _tags = List<SLTag>()
    var tags : SLTagsCollection { get { return self.getCollection(__FUNCTION__, list: _tags) } }
    
    let _events = List<SLEvent>()
    var events : SLEventCollection { get { return self.getCollection(__FUNCTION__, list: _events) } }
}

// MARK: SLTag
typealias SLTagsCollection = SLBaseObjectCollection<SLTag>
class SLTag : SLBaseObject {
    dynamic var value = ""

    convenience init(string : String) {
        self.init()
        self.value = string
    }
    override static func primaryKey() -> String? {
        return "value"
    }
    override func equals<T where T : SLTag>(other: T) -> Bool {
        return super.equals(other) && self.value.equalsCI(other.value)
    }

    private let _assets = List<SLAsset>()
    var assets : SLAssetCollection { get { return self.getCollection(__FUNCTION__, list: _assets) } }
}

// MARK: SLEvent
typealias SLEventCollection = SLBaseObjectCollection<SLEvent>
class SLEvent : SLBaseObjectId {
    dynamic var title = ""
    dynamic var date : NSDate?
    let tags = List<SLTag>()
}