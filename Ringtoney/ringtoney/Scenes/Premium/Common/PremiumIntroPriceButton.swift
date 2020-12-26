//
//  PremiumIntroPriceButton.swift
//  ringtoney
//
//  Created by dong ka on 24/11/2020.
//

import Foundation
class PremiumIntroPriceButton: View {
    
    let stackView = StackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    let titleLabel = Label().then {
        $0.text = "$2.99 per week, auto-renewable"
        $0.font = FontsManager.nasalization.font(size: 15)
        $0.numberOfLines = 1
        $0.textColor = UIColor.init(hexString: "002417")
        $0.textAlignment = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyShadowWithCornerRadius(color: UIColor.init(hexString: "00FFAA")!,
                                    opacity: 0.29,
                                    radius: 19,
                                    edge: .All,
                                    shadowSpace: 19)
    }
    
    override func makeUI() {
        super.makeUI()
        addStackView()
        addTitleLabel()
        
    }
    
    func addStackView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func addTitleLabel() {
        stackView.addArrangedSubview(titleLabel)
    }
    
    
}
