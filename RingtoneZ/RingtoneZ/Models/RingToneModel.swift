//
//  RingToneModel.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 11/30/20.
//

import UIKit
import ObjectMapper

@objcMembers

class RingToneModel: NSObject, Mappable {
    var isSelected = false
    var isPlay = false
    var isDowloadDone = false
    var progress: Float?
    var pathURL: String?
    var origin_url = ""
    var id: Int = 0
    var category_id: Int = 0
    var name: String = ""
    var download_number: Int = 0
    var created_at: String = ""
    var updated_at: String = ""
    
    var databaseID: String?
    
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    // Mappable
    func mapping(map: Map) {
        id               <- map["id"]
        name             <- map["name"]
        category_id      <- map["category_id"]
        pathURL          <- map["original_path"]
        origin_url       <- map["origin_url"]
        updated_at       <- map["updated_at"]
        created_at       <- map["created_at"]
    }
    
}
