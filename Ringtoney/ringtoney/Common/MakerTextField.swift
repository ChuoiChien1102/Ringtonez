//
//  MakerTextField.swift
//  ringtoney
//
//  Created by dong ka on 17/11/2020.
//

import Foundation
class MakerTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 50)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
