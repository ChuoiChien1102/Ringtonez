//
//  PremiumIntroView.swift
//  ringtoney
//
//  Created by dong ka on 24/11/2020.
//

import Foundation
class PremiumIntroView: View {
    
    
    let row1 = PremiumIntroRow().then {
        $0.titleLabel.text = "All premium CONTENT"
    }
    
    let row2 = PremiumIntroRow().then {
        $0.titleLabel.text = "Advanced editing features"
    }
    
    let row3 = PremiumIntroRow().then {
        $0.titleLabel.text = "Cancel any time"
    }
    
    
    
    let stackView = StackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    override func makeUI() {
        super.makeUI()
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        stackView.addArrangedSubview(row1)
        stackView.addArrangedSubview(row2)
        stackView.addArrangedSubview(row3)

        
    }
    
    
}
