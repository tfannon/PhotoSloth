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
    private static var realmNamesInstantiated = Set<String>()

    private var realmConfiguration : Realm.Configuration!
    private var realm : Realm { get { return try! Realm(configuration: realmConfiguration) } }
    
    private var name : String!
    private var path : NSURL!
    private var fullPath : NSURL!
    
    init(name : String = "realm") {
        self.name = name
        configure()
        RealmBase.realmNamesInstantiated.insert(name)
    }
    
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

    private static func getPath(name : String) -> NSURL {
        let v = File.documentDirectory.combine(name)
        return v
    }
    
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
    static func delete(name: String) -> Bool {
        if RealmBase.isNameInstantianted(name) {
            return false
        }
        let path = RealmBase.getPath(name)
        File.deleteDirectory(path)
        return !File.exists(path)
    }
    
    func write(block: () -> Void) {
        try! realm.write(block)
    }
    
    func deleteAll() {
        write {
            self.realm.deleteAll()
        }
    }
    
    func add(object: Object) {
        realm.add(object)
    }
    
    func select<T : Object>(type: T.Type) -> Results<T> {
        return realm.objects(T.self)
    }
    
    func getBaseObjectId<T : Object>(id : String) -> T? {
        let results = self.select(T.self).filter("id = '\(id)'")
        return results.first
    }
    
    func addNotificationBlock(block: NotificationBlock) -> NotificationToken {
        return realm.addNotificationBlock(block)
    }

    func removeNotificationBlock(token: NotificationToken) {
        realm.removeNotification(token)
    }
}










