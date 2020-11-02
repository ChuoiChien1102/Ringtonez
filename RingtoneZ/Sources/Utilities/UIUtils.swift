//
//  UIUtils.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import Foundation
import UIKit

class UIUtils: NSObject {
    
    // store object to user default
    class func storeObjectToUserDefault(_ object: AnyObject, key: String) {
        let dataSave = NSKeyedArchiver.archivedData(withRootObject: object)
        UserDefaults.standard.set(dataSave, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    // get object to user default
    class func getObjectFromUserDefault(_ key: String) -> AnyObject? {
        if let object = UserDefaults.standard.object(forKey: key) {
            return NSKeyedUnarchiver.unarchiveObject(with: object as! Data) as AnyObject?
        }
        return nil
    }
    
    class func removeObjectUserDefault(_ key: String) -> Void {
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: key)
    }
    
    class func removeAllValueUserDefault() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }

    class func getUIID() -> String {
        return (UIDevice.current.identifierForVendor?.uuidString)!
    }
    
    // Format Date
    class func getStringFromDate(_ date: Foundation.Date, formatDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = formatDate
        return dateFormatter.string(from: date)
    }
    
    class func getDateFromString(_ date: String, formatDate: String) -> Foundation.Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = formatDate
        return dateFormatter.date(from: date)!
    }
}
