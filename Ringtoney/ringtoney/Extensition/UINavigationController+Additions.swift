//
//  UINavigationController+Additions.swift
//  dmvpro
//
//  Created by OW01 on 10/5/20.
//

import Foundation

extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
}
