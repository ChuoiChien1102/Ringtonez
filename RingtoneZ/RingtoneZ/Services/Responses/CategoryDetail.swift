//
//  CategoryDetail.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 12/4/20.
//

import Foundation
import ObjectMapper

class CategoryDetail: Mappable {
    var current_page: Int?
    var data: [RingToneModel]?
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
