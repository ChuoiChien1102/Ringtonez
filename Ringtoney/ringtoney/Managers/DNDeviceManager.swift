//
//  DNDeviceManager.swift
//  ringtoney
//
//  Created by dong ka on 03/12/2020.
//

import Foundation
import DeviceKit


class DNDeviceManager: NSObject {
    
    static let device = Device.current
    
    static func isIpad() -> Bool {
        return device.isPad
    }
    
    
    
}
