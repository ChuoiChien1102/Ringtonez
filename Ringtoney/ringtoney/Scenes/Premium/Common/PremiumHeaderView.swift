//
//  PremiumHeaderView.swift
//  ringtoney
//
//  Created by dong ka on 24/11/2020.
//

import Foundation
import SnapKit

class PremiumHeaderView: View {
    
    let closeButton = Button().then {
        $0.setImage(R.image.icon_button_premium_close(), for: .normal)
        $0.contentHorizontalAlignment = .left
    }
    
    let restoreButton = Button().then {
        $0.setTitle("Restore", for: .normal)
        $0.titleLabel?.font = FontsManager.nasalization.font(size: 14)
        $0.setTitleColor(.white, for: .normal)
       
    }
    
    let stackView = StackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    override func makeUI() {
        super.makeUI()
        addStackView()
        addCloseButton()
        stackView.addArrangedSubview(Spacer())
        addRestoreButton()
    }
    
    
    func addStackView () {
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
    }
    
    func addCloseButton() {
        stackView.addArrangedSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.width.equalTo(50)
        }
    }
    
    func addRestoreButton() {
        stackView.addArrangedSubview(restoreButton)

    }
    
    
}
