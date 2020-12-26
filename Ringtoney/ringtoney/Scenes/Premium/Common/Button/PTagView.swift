//
//  PTagView.swift
//  ringtoney
//
//  Created by dong ka on 25/11/2020.
//

import Foundation
class PTagView: View {
    
    let titleLabel = Label().then {
        $0.text = "Best price"
        $0.font = FontsManager.nasalization.font(size: 9)
        $0.numberOfLines = 1
        $0.textColor = UIColor.init(hexString: "ffffff")
        $0.textAlignment = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 12
        self.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMinYCorner]
    }
    
    override func makeUI() {
        super.makeUI()
        
        self.backgroundColor = UIColor.init(hexString: "a17fe0")
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
    }
    
    
}
