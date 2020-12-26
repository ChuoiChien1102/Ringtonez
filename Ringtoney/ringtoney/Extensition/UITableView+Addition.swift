//
//  UITableView+Addition.swift
//  dmvpro
//
//  Created by OW01 on 9/29/20.
//

import Foundation
extension UITableViewCell {
    
    var identifier: String {
        return String(describing: type(of: self))
    }
    
    class var identifier: String {
        return String(describing: self)
    }
    
}
