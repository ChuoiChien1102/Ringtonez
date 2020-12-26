//
//  PremiumIntroRow.swift
//  ringtoney
//
//  Created by dong ka on 25/11/2020.
//

import Foundation
import SnapKit

class PremiumIntroRow : View {
    
    let icon = ImageView().then {
        $0.image = R.image.icon_premium_introrow()
        $0.contentMode = .scaleAspectFit
    }
    
    let titleLabel = Label().then {
        $0.text = "Title here"
        $0.font = FontsManager.nasalization.font(size: 14)
        $0.numberOfLines = 1
        $0.textColor = UIColor.init(hexString: "FFFFFF")
        $0.textAlignment = .left
    }
    
    let stackView = StackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 16
    }
    
    override func makeUI() {
        super.makeUI()
        
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
            
        stackView.addArrangedSubview(icon)
        stackView.addArrangedSubview(titleLabel)
        
        icon.snp.makeConstraints { (make) in
            make.width.equalTo(15)
        }
        
    }
    
    
    
}
