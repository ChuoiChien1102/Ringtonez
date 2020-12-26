//
//  MakerTextFieldview.swift
//  ringtoney
//
//  Created by dong ka on 17/11/2020.
//

import Foundation
import SnapKit

class MakerTextFieldView: View {
    
    
    var textFied: MakerTextField = MakerTextField().then {
        $0.backgroundColor = UIColor.init(hexString: "151824")
        $0.placeholder = "Hello"
        $0.tintColor = .white
        $0.textColor = .white
        $0.attributedPlaceholder = NSAttributedString(string: "Ringtone name",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                  NSAttributedString.Key.font: FontsManager.nasalization.font(size: 17)
                                     ])
    }
    
    let editLabel = Label().then {
        $0.text = "Edit"
        $0.font = FontsManager.nasalization.font(size: 14)
        $0.numberOfLines = 1
        $0.textColor = UIColor.init(hexString: "00FFAA")
        $0.textAlignment = .right
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textFied.layer.cornerRadius = 12
        self.textFied.layer.masksToBounds = true
    }
    
    override func makeUI() {
        super.makeUI()
        
        self.addSubview(textFied)
        textFied.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addSubview(editLabel)
        editLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(50)
        }
        self.textFied.doneAccessory = true
    }
    
    
}
