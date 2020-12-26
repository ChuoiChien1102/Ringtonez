//
//  DatabaseManager.swift
//  ringtoney
//
//  Created by dong ka on 17/11/2020.
//

import Foundation
import Realm
import RealmSwift

protocol DatabaseUpdating: class {
    
    func createRingtone()
    
    func updateRingtone(id: String, newName: String)
    
    func deleteRingtone()
    
}

class DatabaseManager: NSObject {
    
    static let shared = DatabaseManager()
    
    let realm = try! Realm()
    
    class func setup() {
        
        let dbConfig = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = dbConfig
        
        var config = Realm.Configuration()
        FCFileManager.createDirectories(forPath: Configs.FolderPath.database)
        // Use the default directory, but replace the filename with the username
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(Configs.FolderPath.database)/vodka.realm")
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
    
    //MARK:- Create
    
    //From local
    func create( name: String, duration: Double, path: String ) {
        let ringtone = TBRingtone()
        ringtone.id = UUID.init().uuidString.lowercased()
        ringtone.date = Date()
        ringtone.name = name
        ringtone.duration = duration
        ringtone.isPremium = false
        ringtone.path = path
        DispatchQueue.main.async {
            try! self.realm.write {
                log.debug("Create ringtone success")
                self.realm.add(ringtone, update: .modified)
            }
            Broadcaster.notify(DatabaseUpdating.self) {
                $0.createRingtone()
            }
        }
    }
    
    func createPremiumRingtone( name: String,
                                duration: Double,
                                path: String ) {
        let ringtone = TBRingtone()
        ringtone.id = UUID.init().uuidString.lowercased()
        ringtone.date = Date()
        ringtone.name = name
        ringtone.duration = duration
        ringtone.isPremium = true
        ringtone.path = path
        DispatchQueue.main.async {
            try! self.realm.write {
                log.debug("Create ringtone success")
                self.realm.add(ringtone, update: .modified)
            }
            Broadcaster.notify(DatabaseUpdating.self) {
                $0.createRingtone()
            }
        }
    }
    
    //MARK:- Edit
    func editRingtoneName(NewName name: String, id: String) {
        
        guard let ringtone = realm.objects(TBRingtone.self).filter({$0.id == id}).first else { return }
        
        DispatchQueue.main.async {
            
            try! self.realm.write {
                log.debug("Change name ringtone success")
                ringtone.name = name
            }
            
            Broadcaster.notify(DatabaseUpdating.self) {
                $0.updateRingtone(id: id, newName: name)
            }
            
        }

    }
    //MARK:- Delete
    func removeRingtone(id: String) {
        
        guard let ringtone = realm.objects(TBRingtone.self).filter({$0.id == id}).first else { return }
        
        DispatchQueue.main.async {
            
            try! self.realm.write {
                log.debug("Delete ringtone success")
                self.realm.delete(ringtone)
            }
            
            Broadcaster.notify(DatabaseUpdating.self) {
                $0.deleteRingtone()
            }
//
        }
    }
    
    //MARK:- List
    func listPremiumTones() -> [Ringtone] {

        
        var ringtones:[Ringtone] = []
        
        let listRingtone = realm.objects(TBRingtone.self).filter {$0.isPremium == true}.sorted {$0.date > $1.date}
        
        for ringtone in listRingtone {
            let rt = Ringtone.init()
            rt.id = 0
            rt.databaseID = ringtone.id
            rt.name = ringtone.name
            rt.audioPath =  ringtone.path
            rt.isLocal = true
            ringtones.append(rt)
        }
        
        return ringtones

    }
    
    func listRingMakerTones() -> [Ringtone] {

        
        var ringtones:[Ringtone] = []
        
        let listRingtone = realm.objects(TBRingtone.self).filter {$0.isPremium == false}.sorted {$0.date > $1.date}
        
        for ringtone in listRingtone {
            let rt = Ringtone.init()
            rt.id = 0
            rt.databaseID = ringtone.id
            rt.name = ringtone.name
            rt.audioPath =  ringtone.path
            rt.isLocal = true
            ringtones.append(rt)
        }
        
        return ringtones

    }
    
    
}
