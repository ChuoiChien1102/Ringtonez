//
//  UIScrollView+Addition.swift
//  dmvpro
//
//  Created by OW01 on 9/28/20.
//

import Foundation
import UIKit

extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
   }
}
