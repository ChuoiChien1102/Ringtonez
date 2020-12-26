//
//  DKEvents.swift
//  ringtoney
//
//  Created by dong ka on 10/29/20.
//

import Foundation
//import Firebase
//import FBSDKCoreKit


class DKEvents: NSObject {
    
    class func log(_ event: DKEventUnit) {
        guard let eventName = event.name(),
              let param = event.parameters() else { return }
        //        Analytics.logEvent(eventName, parameters: param)
        //        AppEvents.logEvent(AppEvents.Name(rawValue: eventName), parameters: param)
    }
    
}

enum DKEventUnit {
    
    //    case someEventWithoutParam
    //    case awesomeEvent( someParam: Any)
    
}

extension DKEventUnit {
    
    func name() -> String? {
        switch self {
        //case .someEventWithoutParam:
        //return "someEventWithoutParam"
        //case .awesomeEvent:
        //return "awesomeEvent"
        }
    }
    
    func parameters() -> [String: Any]? {
        switch self {
        //            case .someEventWithoutParam:
        //             return [:]
        //        case .awesomeEvent(someParam: let someParam):
        //            return ["someParam_name":someParam]
        }
    }
    
}
