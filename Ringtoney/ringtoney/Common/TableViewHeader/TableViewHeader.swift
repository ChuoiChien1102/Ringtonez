//
//  TableViewHeader.swift
//  ringtoney
//
//  Created by dong ka on 11/5/20.
//

import Foundation
class TableViewHeader: View {
    
    let stackView = StackView().then {
        $0.axis = .horizontal
    }
    
    var title = Label().then {
        $0.text = "Top Categories"
        $0.font = FontsManager.nasalization.font(size: 20)
        $0.numberOfLines = 1
        $0.textColor = UIColor.init(hexString: "6A72A0")
    }

    override func makeUI() {
        super.makeUI()
        addStackView()
        addTitleLabel()
    }
    
    func addStackView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func addTitleLabel() {
        stackView.addArrangedSubview(title)
        //Add spacer
        stackView.addArrangedSubview(Spacer())
    }
}
