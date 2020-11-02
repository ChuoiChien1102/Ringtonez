//
//  LoginRespone.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginRespone: Mappable {
    var error_code: String?
    var message: String?
    var session: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        error_code <- map["error_code"]
        message <- map["message"]
        session <- map["session"]
    }
}
