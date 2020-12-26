//
//  PBButton.swift
//  ringtoney
//
//  Created by dong ka on 25/11/2020.
//

import Foundation
class PBButton: View {
    
    let stackView = StackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 0
    }
    
    let titleLabel = Label().then {
        $0.text = "$4.99 per week, auto-renewable"
        $0.font = FontsManager.nasalization.font(size: 14)
        $0.numberOfLines = 1
        $0.textColor = UIColor.init(hexString: "002417")
        $0.textAlignment = .center
    }
    
    let descLabel = Label().then {
        $0.text = "Free trial 3 days"
        $0.font = FontsManager.nasalization.font(size: 14)
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
        addDescLabel()
        addTitleLabel()
        
    }
    
    func addStackView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(8)
        }
    }
    
    func addTitleLabel() {
        stackView.addArrangedSubview(titleLabel)
    }
    
    func addDescLabel() {
        stackView.addArrangedSubview(descLabel)
    }
    
    
}
