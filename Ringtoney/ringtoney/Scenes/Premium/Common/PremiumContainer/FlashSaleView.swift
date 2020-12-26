//
//  FlashSaleView.swift
//  ringtoney
//
//  Created by dong ka on 25/11/2020.
//

import Foundation

class FlashSaleView: View , PremiumContainerProtocol{
    
    let premiumButton = PAButton().then {
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor.init(hexString: "00FFAA")
    }
    
    let limitedLabel = Label().then {
        $0.text = "Limited time: 5:00 minutes"
        $0.font = FontsManager.nasalization.font(size: 17)
        $0.numberOfLines = 1
        $0.textColor = UIColor.init(hexString: "FFFFFF")
        $0.textAlignment = .center
    }
    
    let flashSaleImageView = SpringImageView().then {
        $0.image = R.image.icon_flash_sale()
        $0.contentMode = .scaleAspectFit
    }
    
    override func makeUI() {
        super.makeUI()
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        addButton()
        addLimitedLabel()
        addFlashSaleImageView()
    }
    
    func addButton() {
        addSubview(premiumButton)
        premiumButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    func addLimitedLabel() {
        addSubview(limitedLabel)
        limitedLabel.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    func addFlashSaleImageView() {
        
        addSubview(flashSaleImageView)
        flashSaleImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.width.height.equalTo(74)
        }
        
    }
    
    
    
}
