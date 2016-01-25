//
//  Realm.swift
//  PhotoDeclutter_1
//
//  Created by Adam Rothberg on 1/23/16.
//  Copyright © 2016 Adam Rothberg. All rights reserved.
//

import Foundation
import RealmSwift

class RealmBase
{
    private let fileName = "default.realm"

    private var _realm : Realm?
    private var realm : Realm { get { return _realm! } }
    
    private var name : String!
    private var path : NSURL!
    private var fullPath : NSURL!
    
    init(name : String = "realm") {
        self.name = name
        configure()
    }
    
    private static func getPath(name : String) -> NSURL {
        let v = File.documentDirectory.combine(name)
        return v
    }
    
    private func configure() {
        self.path = RealmBase.getPath(self.name)
        File.createDirectory(path)
        self.fullPath = path.combine(fileName)
        
        let config = Realm.Configuration(
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: migration,
            
            // fullpath to file
            path: fullPath.resourceSpecifier,
            
            // readonly
            readOnly: false
        )

        _realm = try! Realm(configuration: config)
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
    static func delete(name: String) {
        let path = RealmBase.getPath(name)
        File.deleteDirectory(path)
    }
    
    func reset() {
        delete()
        configure()
    }
    
    // deletes the database
    func delete() {
        RealmBase.delete(self.name)
        _realm?.invalidate()
        _realm = nil
    }
    
    func write(block: () -> Void) {
        try! realm.write(block)
    }
    
    func add(object: Object) {
        realm.add(object)
    }
    
    func select<T : Object>(type: T.Type) -> Results<T> {
        return realm.objects(T.self)
    }
    
    func getBaseObjectId<T : Object>(id : String) -> T? {
        let results = self.select(T.self).filter("Id = '\(id)'")
        return results.first
    }
    
    func addNotificationBlock(block: NotificationBlock) -> NotificationToken {
        return realm.addNotificationBlock(block)
    }

    func removeNotificationBlock(token: NotificationToken) {
        realm.removeNotification(token)
    }
}










