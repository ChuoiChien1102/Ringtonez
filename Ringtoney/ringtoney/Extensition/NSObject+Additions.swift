//
//  NSObject+Addition.swift
//  dmvpro
//
//  Created by OW01 on 9/22/20.
//

import Foundation

extension NSObject {
    
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
    
}
