//
//  UICollectionViewCell+Additions.swift
//  dmvpro
//
//  Created by OW01 on 9/22/20.
//

import Foundation

extension UICollectionViewCell {
    
    var identifier: String {
        return String(describing: type(of: self))
    }
    
    class var identifier: String {
        return String(describing: self)
    }
    
}
