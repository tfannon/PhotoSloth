//
//  Realm.swift
//  PhotoDeclutter_1
//
//  Created by Adam Rothberg on 1/23/16.
//  Copyright © 2016 Adam Rothberg. All rights reserved.
//

import Foundation
import RealmSwift

//
//  this is the base 'abstract' class for any specialized realm instances that manage a single realm store
//  this uses the concept of a string 'name' to identify a given realm database
//  general purpose functions are in this class.
//  specialized functions particular to a given store are included within the subclasses of this class
//
//  IDEALLY: all access to Realm is done though this class/subclass so that we localize everything
//      here - this allows us to do all sorts of wonderful things like instrumenting, diagnosing, 
//      and removing friction from Realm usage
//
class RealmBase
{
    // file name for the realm store
    private let fileName = "default.realm"
    // tracks what realm names have been instantiated across all RealmBase instances
    private static var realmNamesInstantiated = Set<String>()

    // the realm configuration
    private var realmConfiguration : Realm.Configuration!
    private var realm : Realm { get { return try! Realm(configuration: realmConfiguration) } }
    
    // this realm instance's name
    private var name : String!
    // this realm instance's path
    private var path : NSURL!
    // this realm instance's full path
    private var fullPath : NSURL!
    
    // initializes the realm with the provided name
    init(name : String = "realm") {
        self.name = name
        configure()
        RealmBase.realmNamesInstantiated.insert(name)
    }
    
    // configures the realm associated with this instance
    private func configure() {
        self.path = RealmBase.getPath(self.name)
        File.createDirectory(path)
        self.fullPath = path.combine(fileName)
        
        realmConfiguration = Realm.Configuration(
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: migration,
            
            // fullpath to file
            path: fullPath.resourceSpecifier,
            
            // readonly
            readOnly: false
        )
    }
    
    // MARK - Statics

    // returns the location of the named realm
    private static func getPath(name : String) -> NSURL {
        let v = File.documentDirectory.combine(name)
        return v
    }
    
    // returns true if the realm name has already be instantiated
    static func isNameInstantianted(name : String) -> Bool {
        return RealmBase.realmNamesInstantiated.contains(name)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    // handles the schema migration across versions
    //////////////////////////////////////////////////////////////////////////////////////////
    private func migration(migration: Migration, oldSchemaVersion: UInt64) {
        // We haven’t migrated anything yet, so oldSchemaVersion == 0
        if (oldSchemaVersion < 0) {
            // Nothing to do!
            // Initial version.
            // I liked having this as a placeholder to aid with future migrations
        }
    }
    
    // MARK: public functions
    
    // deletes the database and recreates a new one
    // this can only be called if the realm was not yet instantiated
    static func delete(name: String) -> Bool {
        if RealmBase.isNameInstantianted(name) {
            return false
        }
        let path = RealmBase.getPath(name)
        File.deleteDirectory(path)
        return !File.exists(path)
    }
    
    // updates an object within a realm
    func write(block: () -> Void) {
        try! realm.write(block)
    }
    
    // deletes all objects in a realm
    func deleteAll() {
        write {
            self.realm.deleteAll()
        }
    }
    
    // adds an object to the realm
    func add(object: Object) {
        realm.add(object)
    }
    
    // returns results matching provided type
    func select<T : Object>(type: T.Type) -> Results<T> {
        return realm.objects(T.self)
    }
    
    // returns an object by it's Id
    func get<T : Object>(id : String) -> T? {
        let results = self.select(T.self).filter("id = '\(id)'")
        return results.first
    }
    
    // returns a notificationblock for use with Realm
    func addNotificationBlock(block: NotificationBlock) -> NotificationToken {
        return realm.addNotificationBlock(block)
    }

    // emoves a notificationblock for use with Realm
    func removeNotificationBlock(token: NotificationToken?) {
        if let t = token {
            realm.removeNotification(t)
        }
    }
}










