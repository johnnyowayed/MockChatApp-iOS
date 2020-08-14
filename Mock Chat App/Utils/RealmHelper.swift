//
//  RealmHelper.swift
//  Mobile Chat Test
//
//  Created by Johnny Owayed on 8/12/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//


import UIKit
import Realm
import RealmSwift

class RealmHelper: Object {
    final class func realm() -> Realm {
        let realm = try! Realm()

        return realm
    }
    
    // MARK: -
    // MARK: SaveOrUpdate
    @objc func saveOrUpdate() {
        let realm = RealmHelper.realm()
        
        // update or add in realm
        if realm.isInWriteTransaction {
            realm.add(self, update: .modified)
        } else {
            try! realm.write {
                realm.add(self, update: .modified)
            }
        }
    }
    
    // MARK: -
    // MARK: Remove
    func remove() {
        let realm = RealmHelper.realm()
        if realm.isInWriteTransaction {
            realm.delete(self)
        } else {
            try! realm.write {
                realm.delete(self)
            }
        }
    }
    
    // MARK: -
    // MARK: Has Objects
    class func hasObjects() -> Bool {
        let realm = RealmHelper.realm()
        let results = realm.objects(self)
        if results.count > 0 {
            return true
        }
        return false
    }
    
    // MARK: -
    // MARK: Wipe database
    @objc final class func wipeDatabase() {
        let realm = RealmHelper.realm()
        if realm.isInWriteTransaction {
            realm.deleteAll()
        } else {
            try! realm.write {
                realm.deleteAll()
            }
        }
    }
    
    // MARK: -
    // MARK: Write
    final class func write(_ code: () -> ()) {
        let realm = RealmHelper.realm()
        if realm.isInWriteTransaction {
            code()
        } else {
            // update or add in realm
            try! realm.write {
                code()
            }
        }
    }
    
    // MARK: -
    // MARK: Write
    final func writeAndSave(_ code: () -> ()) {
        let realm = RealmHelper.realm()
        // update or add in realm
        if realm.isInWriteTransaction {
            code()
            realm.add(self, update: .modified)
        } else {
            try! realm.write {
                code()
                realm.add(self, update: .modified)
            }
        }
    }
    
    // MARK: -
    // MARK: Write
    final func createCopy<T>() -> T {
        var object:T!
        let realm = RealmHelper.realm()
        if realm.isInWriteTransaction {
            object = realm.create(T.self as! Object.Type, value: self, update: .modified) as? T
        } else {
            // update or add in realm
            try! realm.write {
                object = realm.create(T.self as! Object.Type, value: self, update: .modified) as? T
            }
        }
        return object
    }
    
    // MARK: -
    // MARK: Is In Database
    final class func isInDatabase(intPrimaryKey primaryKey: Int) -> Bool {
        let realm = RealmHelper.realm()
        return realm.object(ofType: self, forPrimaryKey: primaryKey) != nil
    }
    
    final class func isInDatabase(strPrimaryKey primaryKey: String) -> Bool {
        let realm = RealmHelper.realm()
        return realm.object(ofType: self, forPrimaryKey: primaryKey) != nil
    }
    
    // MARK: -
    final class func object<T>(forPrimaryKey primaryKey: String) -> T? {
        let realm = RealmHelper.realm()
        return realm.object(ofType: self, forPrimaryKey: primaryKey) as? T
    }
    
    // MARK: Check if object is in database
    final class func hasObject(forPrimaryKey primaryKey: String) -> Bool {
        return self.object(forPrimaryKey: primaryKey) != nil
    }
    
    class func allObjects<T>() -> [T] {
        let realm = RealmHelper.realm()
        let results = realm.objects(self)
        return results.compactMap { $0 as? T }
    }
    
    // MARK: -
    // MARK: Filter
    class func filter<T>(forKey key: String, value: Int) -> [T] {
        let realm = RealmHelper.realm()
        let predicate = NSPredicate(format: "%@ = %d", key, value)
        let filteredResults = realm.objects(self).filter(predicate)
        let castedResults: [T] = filteredResults.compactMap { $0 as? T }
        
        return castedResults
    }
    
    class func filter<T>(forKey key: String, value: Float) -> [T] {
        let realm = RealmHelper.realm()
        let predicate = NSPredicate(format: "%@ = %f", key, value)
        let filteredResults = realm.objects(self).filter(predicate)
        let castedResults: [T] = filteredResults.compactMap { $0 as? T }
        
        return castedResults
    }
    
    class func filter<T>(forKey key: String, value: Double) -> [T] {
        let realm = RealmHelper.realm()
        let predicate = NSPredicate(format: "%@ = %f", key, value)
        let filteredResults = realm.objects(self).filter(predicate)
        let castedResults: [T] = filteredResults.compactMap { $0 as? T }
        
        return castedResults
    }
    
    class func filter<T>(forKey key: String, value: String) -> [T] {
        let realm = RealmHelper.realm()
        
        let predicate = NSPredicate(format: String.init(format: "%@ = '%@'", key, value))
        let filteredResults = realm.objects(self).filter(predicate)
        let castedResults: [T] = filteredResults.compactMap { $0 as? T }
        
        return castedResults
    }
}

extension Array where Element : Object {
    func saveInRealm() {
        let realm = RealmHelper.realm()
        if realm.isInWriteTransaction {
            realm.add(self, update: .modified)

        } else {
            // update or add in realm
            try! realm.write {
                realm.add(self, update: .modified)
            }
        }
    }
}

extension List {
    func toArray<T>() -> [T] {
        return self.compactMap { $0 as? T }
    }
}

// MARK: - Local
extension RealmHelper {
    // used for local realm
    final class func setupLocalRealmForUser(username: String) {
        // Use the default directory, but replace the filename with the username
        var config = Realm.Configuration.defaultConfiguration
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(username).realm")
        Realm.Configuration.defaultConfiguration = config
        
        // printing the realm path
        var realmPath = Realm.Configuration.defaultConfiguration.fileURL?.absoluteString
        realmPath = realmPath?.replacingOccurrences(of: "file://", with: "")
        print("realm file path: \(realmPath ?? "")")
    }
}

