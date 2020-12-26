//
//  TBRingtone.swift
//  ringtoney
//
//  Created by dong ka on 17/11/2020.
//

import Foundation
import Realm
import RealmSwift

class TBRingtone : Object {
    
    @objc dynamic var id: String = "0"
    @objc dynamic var name: String = ""
    @objc dynamic var duration: Double = 0
    @objc dynamic var path: String = ""
    @objc dynamic var date: Date = Date() //Saved date
    
    @objc dynamic var isPremium: Bool = false

    override class func primaryKey() -> String? {
        return "id"
    }

}
