//
//  PremiumNavigationView.swift
//  ringtoney
//
//  Created by dong ka on 11/2/20.
//

import Foundation
//import Shift

class PremiumNavigationView: View {
    
    let bag = DisposeBag.init()
    
    let stackView = StackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    let premiumButton = Button().then {
        $0.setImage(R.image.icon_button_premium(), for: .normal)
    }
    
    override func makeUI() {
        super.makeUI()
        
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview()
        }
        
        stackView.addArrangedSubview(Spacer())
        stackView.addArrangedSubview(premiumButton)
        premiumButton.snp.makeConstraints { (make) in
            make.width.equalTo(120)
        }
        
        IAP_OBSERVABLE
            .subscribe(onNext:{[weak self] isPurchase in
                guard let self = self else { return }
                    if isPurchase {
                        self.premiumButton.isHidden = true
                        self.premiumButton.isUserInteractionEnabled = false
                    } else {
                        self.premiumButton.isHidden = false
                        self.premiumButton.isUserInteractionEnabled = true
                    }
            })
            .disposed(by: bag)
    }
    
}
