//
//  Ringtone.swift
//  ringtoney
//
//  Created by dong ka on 19/11/2020.
//

import Foundation
import ObjectMapper

class Ringtone : NSObject, Mappable {
    
    var onChangeValue: ((Double) -> Void)?
    var onChangePlayPause: ((Bool) -> Void)?
    
    var id: Int = 0
    var category_id: Int = 0
    var name: String = ""
    var origin_url: String = ""
    var like_number: Int = 0
    var download_number: Int = 0
    var created_at: String = ""
    var updated_at: String = ""
    var original_path: String = "" //Sever
    
    var totalDuration: Double = 40
    var audioPath: String = "" //Local
    var isFavorite: Bool = false
    var isLocal: Bool = false
    
    var databaseID: String?
    
    var audioURL: URL? {
        get {
            let test_audio =  Bundle.main.url(forResource: "audio2", withExtension: "mp3")
            if isLocal {
                log.debug("Phát nhạc từ local")
                return FCFileManager.urlForItem(atPath: audioPath)
            } else {
                log.debug("Phát nhạc từ server")
                return original_path.isEmpty ?  test_audio : URL.init(string: original_path)
            }
        }
    }
    
    var currentDuration: Double = 0 {
        didSet {
            currentDuration > totalDuration ? Void() : onChangeValue?(currentDuration/totalDuration)
        }
    }
    
    var isPlay: Bool = false {
        didSet {
            onChangePlayPause?(isPlay)
        }
    }
    
    //Mappable
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    // Mappable
    func mapping(map: Map) {
        id               <- map["id"]
        category_id      <- map["category_id"]
        name             <- map["name"]
        origin_url       <- map["origin_url"]
        like_number      <- map["like_number"]
        download_number  <- map["download_number"]
        created_at       <- map["created_at"]
        updated_at       <- map["updated_at"]
        original_path    <- map["original_path"]
    }
    
    
}
