//
//  BaseNavigationview.swift
//  ringtoney
//
//  Created by dong ka on 11/5/20.
//

import Foundation
class BaseNavigationview: View {
    
    let bag = DisposeBag.init()

    let stackView = StackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    let titleLabel = UILabel().then {
        $0.text = "Title here"
        $0.font = FontsManager.nasalization.font(size: 17)
        $0.numberOfLines = 1
        $0.textColor = UIColor.init(hexString: "FFFFFF")
        $0.textAlignment = .center
    }
    
    let premiumButton = Button().then {
        $0.setImage(R.image.icon_button_premium(), for: .normal)
    }
    
    var isHiddenPremiumButton = true {
        didSet {
            premiumButton.isHidden = isHiddenPremiumButton
        }
    }

        
    override func makeUI() {
        super.makeUI()
        
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview()
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        stackView.addArrangedSubview(Spacer())
        stackView.addArrangedSubview(premiumButton)
        premiumButton.snp.makeConstraints { (make) in
            make.width.equalTo(120)
        }
        premiumButton.isHidden = isHiddenPremiumButton

        IAP_OBSERVABLE
            .subscribe(onNext:{[weak self] isPurchase in
                guard let self = self else { return }
                if self.isHiddenPremiumButton == false {
                    if isPurchase {
                        self.premiumButton.isHidden = true
                        self.premiumButton.isUserInteractionEnabled = false
                    } else {
                        self.premiumButton.isHidden = false
                        self.premiumButton.isUserInteractionEnabled = true
                    }
                } else {
                    self.premiumButton.isHidden = true
                    self.premiumButton.isUserInteractionEnabled = false
                }
            })
            .disposed(by: bag)
        
    }
 
}
