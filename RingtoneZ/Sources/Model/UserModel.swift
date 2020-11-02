//
//  UserModel.swift
//  BRIS
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import Foundation
import ObjectMapper

class UserModel: NSObject, NSCoding, Mappable {
    
    var id: Int?
    var email: String?
    var session: String?
    var type_user: Int?
    
    override init() {}
    
    required init?(map: Map){
        super.init()
        mapping(map: map)
    }
    
    required init(coder decoder: NSCoder) {
        super.init()
        id = decoder.decodeObject(forKey: "id") as? Int
        email = decoder.decodeObject(forKey: "email") as? String
        session = decoder.decodeObject(forKey: "session") as? String
        type_user = decoder.decodeObject(forKey: "type_user") as? Int
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(session, forKey: "session")
        aCoder.encode(type_user, forKey: "type_user")
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        email <- map["email"]
        session <- map["session"]
        type_user <- map["type_user"]
    }
}
