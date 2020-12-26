//
//  PremiumSingleWView.swift
//  ringtoney
//
//  Created by dong ka on 25/11/2020.
//

import Foundation

class PremiumSingleWView: View , PremiumContainerProtocol{
    
    let premiumButton = PBButton().then {
        
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor.init(hexString: "00FFAA")
    }

    override func makeUI() {
        super.makeUI()
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        addButton()
    }
    
    
    func addButton() {
 
        addSubview(premiumButton)
        premiumButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        
    }

 
}
