//
//  FontsManager.swift
//  ringtoney
//
//  Created by dong ka on 11/2/20.
//

import Foundation

enum FontsManager: String {
    case nasalization = "Nasalization"
    
    func font(size: CGFloat) -> UIFont {
        switch self {
        case .nasalization:
            return UIFont.init(name: self.rawValue, size: size)!
        default:
            return UIFont.systemFont(ofSize: 17, weight: .regular)
        }
    }
    
}
