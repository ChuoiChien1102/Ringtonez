//
//  StackView.swift
//  ringtoney
//
//  Created by dong ka on 10/29/20.
//

import UIKit

class StackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        spacing = inset
        axis = .vertical
        // self.distribution = .fill

        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }
}
