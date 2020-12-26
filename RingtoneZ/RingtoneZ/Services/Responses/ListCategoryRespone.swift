//
//  ListCategoryRespone.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import Foundation
import ObjectMapper

class ListCategoryRespone: Mappable {
    var current_page: Int?
    var data: [CategoryModel]?
    var path: String?
    var last_page = 1
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        current_page <- map["current_page"]
        data <- map["data"]
        path <- map["path"]
        last_page <- map["last_page"]
    }
}
