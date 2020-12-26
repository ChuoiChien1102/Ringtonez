//
//  Constants.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import Foundation
import UIKit

enum Keys {
    
    case weekly, lifetime
    case appSpecificSharedSecret
    
    var appId: String {
        switch self {
        case .appSpecificSharedSecret:
            return "73a3ef862da24e76bab9a3c822090505"
        case .weekly: // 3-days free trial
            return "com.artermisstudio.best.ringtone.weekly"
        case .lifetime: //one year subscription
            return "com.artermisstudio.best.ringtone.lifetime"
        }
    }
}

struct App {
    static let name: String = "Best Ringtones For iPhone !!"
    static let termOfUse: String = "https://sites.google.com/view/zero9studio"
    static let appID: String = "1544296992" //real
    static let emailSupport = "artermisstudio8888@gmail.com"
    static let ituneURL = "https://itunes.apple.com/us/app/id\(appID)"
}

struct Network {
    static let baseUrl = "http://wallpaperapi.cf/"
}

/*********************
 Check width, height Screen
 ********************/
let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad

let WIDTH_DEVICE = UIScreen.main.bounds.size.width
let HEIGHT_DEVICE = UIScreen.main.bounds.size.height

let IS_IPHONE_5_5S_SE = (WIDTH_DEVICE == 320) && (HEIGHT_DEVICE == 568) && IS_IPHONE
let IS_IPHONE_6_6S_7_8 = (WIDTH_DEVICE == 375) && (HEIGHT_DEVICE == 667) && IS_IPHONE
let IS_IPHONE_6PLUS_7PLUS_8PLUS = (WIDTH_DEVICE == 414) && (HEIGHT_DEVICE == 736) && IS_IPHONE
let IS_IPHONE_X_XS = (WIDTH_DEVICE == 375) && (HEIGHT_DEVICE == 812) && IS_IPHONE
let IS_IPHONE_XR_XSMAX = (WIDTH_DEVICE == 414) && (HEIGHT_DEVICE == 896) && IS_IPHONE

let KEY_IS_SKIP = "Skip"
let KEY_IS_PREMIUM = "Premium"
let KEY_IS_LIFETIME_ENABLE = "Lifetime"
let KEY_DOWNLOAD_COUNT = "Download_count"
let KEY_LISTENT_COUNT = "Listen_count"

struct IS_FIRST_IAP {
    static var isFirstIAP = true
}

struct FONT_DESCRIPTION_NAME {
    static let FONT_SYMBOL = "Symbol"
}

struct ERROR_CONNECTION{
    static let ERROR_NO_INTERNET = "Không có kết nối mạng. Kiểm tra lại kết nối mạng!"
    static let ERROR_HTTP_REQUEST = "Lỗi kết nối. Vui lòng thử lại"
}

struct TITLE_ALERT {
    static let TITLE_ERROR         = "Lỗi"
    static let TITLE_OK            = "Thông báo"
}

struct FolderPath {
    static let ringtone = ".audio"
    static let database = "absolutvodka2"
}

