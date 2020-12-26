//
//  Configs.swift
//  ringtoney
//
//  Created by dong ka on 10/29/20.
//

import Foundation



// All keys are demonstrative and used for the test.
enum Keys {
    
    case weekly, yearly
    case monthy
    case appSpecificSharedSecret
    
    var appId: String {
        switch self {
        case .appSpecificSharedSecret:
            return "0e55c84961974f52aa4cd5a148a4187d"
        case .monthy:
            return "com.absolutvodka.musicringtones.premium.monthy"
        case .weekly: // 3-days free trial
            return "com.absolutvodka.musicringtones.premium.weekly"
        case .yearly: //one year subscription
            return "com.absolutvodka.musicringtones.premium.yearly"
        }
    }
}


struct Configs {
    
    struct App {
        static let name: String = "Music Ringtones for iPhone !!"
        static let termOfUse: String = "https://sites.google.com/view/zero9studio"
        static let appID: String = "1542514522" //real
        static let emailSupport = "artermisstudio8888@gmail.com"
        static let ituneURL = "https://itunes.apple.com/us/app/id\(appID)"
    }
    
    struct Network {
        static let baseUrl = "http://wallpaperapi.cf/"
    }
    
    struct BaseDimensions {
        static let inset: CGFloat = 8
        static let tabBarHeight: CGFloat = 58
        static let toolBarHeight: CGFloat = 66
        static let navBarWithStatusBarHeight: CGFloat = 64
        static let cornerRadius: CGFloat = 5
        static let borderWidth: CGFloat = 1
        static let buttonHeight: CGFloat = 40
        static let textFieldHeight: CGFloat = 40
        static let tableRowHeight: CGFloat = 36
        static let segmentedControlHeight: CGFloat = 40
    }
    
    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        static let Tmp = NSTemporaryDirectory()
    }
    
    struct UserDefaultsKeys {
        static let bannersEnabled = "BannersEnabled"
    }
    
    struct FolderPath {
        static let ringtone = ".audio"
        static let database = ".absolutvodka2"
    }
    
    struct DefaultValue {
        static let litmitOffer = 3600
    }
}
