//
//  PremiumWYView.swift
//  ringtoney
//
//  Created by dong ka on 25/11/2020.
//

import Foundation

class PremiumWYView: View , PremiumContainerProtocol{
    
    let weeklyButton = PCButton().then {
        $0.descLabel.text = "Free trial 3 days"
        $0.titleLabel.text = "then $4.99 per week, auto-renewable"
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.tagView.titleLabel.text = "Popular"
        //$0.backgroundColor = UIColor.init(hexString: "00FFAA")
    }
    
    let monthyButton = PCButton().then {
        
        $0.descLabel.text = "Free trial 7 days"
        $0.titleLabel.text = "then $12.99 per month, auto-renewable"
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.tagView.titleLabel.text = "Best value"
        //$0.backgroundColor = UIColor.init(hexString: "00FFAA")
    }

    
    let yearlyButton = PCButton().then {
        
        $0.descLabel.text = "One - Year Subscription"
        $0.titleLabel.text = "39.99$ per year, auto-renewable"
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.tagView.titleLabel.text = "Best price"
        //$0.backgroundColor = UIColor.init(hexString: "00FFAA")
    }
    
    
    let stackView = StackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 16
    }

    override func makeUI() {
        super.makeUI()
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        addStackView()
        addButton()
        
        weeklyButton.setSelected(true)
        yearlyButton.setSelected(false)
        
    }
 
    func addStackView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func addButton() {
 
        stackView.addArrangedSubview(weeklyButton)
        stackView.addArrangedSubview(monthyButton)
        stackView.addArrangedSubview(yearlyButton)
        
    }

 
}
