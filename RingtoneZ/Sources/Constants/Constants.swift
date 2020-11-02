//
//  Constants.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import Foundation
import UIKit

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

/*********************
 Key Observer
 ********************/
let KEY_IS_SAVEPASS         = "savePass"
let KEY_ACCOUNT             = "account"
let KEY_PASSWORD            = "password"
let KEY_SESSION             = "session"
let KEY_USER_INFO           = "userinfo"

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

enum TYPE_USER: Int {
    case NVKD = 0
    case GD_TTKD
    case GD_PBH
}
