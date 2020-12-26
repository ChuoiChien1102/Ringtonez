//
//  PremiumFooterView.swift
//  ringtoney
//
//  Created by dong ka on 24/11/2020.
//

import Foundation
import SnapKit

class PremiumFooterView: View {
    
    let termOfUseButton = Button().then {
        $0.setTitle("Terms of Service and Privacy Policy.", for: .normal)
        $0.titleLabel?.font = FontsManager.nasalization.font(size: 12)
        $0.setTitleColor(UIColor.init(hexString: "00FFA8"), for: .normal)
    }
    
    let privacyPolicyButton = Button().then {
        $0.isHidden = true
        $0.setTitle("", for: .normal)
        $0.titleLabel?.font = FontsManager.nasalization.font(size: 14)
        $0.setTitleColor(UIColor.init(hexString: "00FFA8"), for: .normal)
    }
    
    let stackView = StackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 4
    }
    
    let premiumDescLabel = Label().then {
        $0.font = FontsManager.nasalization.font(size: 9)
        $0.numberOfLines = 0
        $0.textColor = UIColor.init(hexString: "FFFFFF")
        $0.textAlignment = .justified
    }

    
    override func makeUI() {
        super.makeUI()
        addStackView()
        addTermOfUseButton()
        //stackView.addArrangedSubview(Spacer())
        addPrivacyPolicyButton()
    }
    
    
    func addStackView () {
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()

        }
    }
    
    func addTermOfUseButton() {
        stackView.addArrangedSubview(premiumDescLabel)
        stackView.addArrangedSubview(termOfUseButton)
        termOfUseButton.snp.makeConstraints { (make) in
            make.height.equalTo(30)
        }
        premiumDescLabel.text = txt

    }
    
    func addPrivacyPolicyButton() {
        stackView.addArrangedSubview(privacyPolicyButton)
    }
    
    
    let txt =
        "By subscribing, you authorize us to charge the subscription cost according to selected plan to your iTunes Account. You can cancel at any time. Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period. Account will be charged for renewal within 24-hours prior to the end of the current period. Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase."
    
}
