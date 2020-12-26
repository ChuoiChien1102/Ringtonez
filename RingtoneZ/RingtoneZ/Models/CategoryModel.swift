//
//  CategoryModel.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 12/3/20.
//

import Foundation
import ObjectMapper

@objcMembers
class CategoryModel: NSObject, Mappable {
    
    var title: String {
        get {
            return self.name
        }
    }
    
    var id: Int = 0
    var name: String = "The Test name"
    var thumbnail_image = "" //Khong su dung
    var thumbnail_path = ""
    var updated_at = ""
    var created_at = ""
    var icon_path = ""
    
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
        thumbnail_image  <- map["thumbnail_image"]
        thumbnail_path   <- map["thumbnail_path"]
        updated_at       <- map["updated_at"]
        created_at       <- map["created_at"]
        icon_path        <- map["icon_path"]
    }
    
    var imageURL: URL? {
        get {
            return URL.init(string: thumbnail_path)
        }
    }
    
    var iconURL: URL? {
        get {
            return URL.init(string: icon_path)
        }
    }
    
}
