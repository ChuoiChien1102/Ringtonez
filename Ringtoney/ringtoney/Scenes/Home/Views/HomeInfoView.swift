//
//  HomeInfoView.swift
//  ringtoney
//
//  Created by dong ka on 11/3/20.
//

import Foundation
class HomeInfoView : View {
    
    let stackView = StackView().then {
        $0.axis = .vertical
    }
    
    var title = Label().then {
        $0.font = FontsManager.nasalization.font(size: 28)
        $0.numberOfLines = 2
        $0.textColor = .white
    }
    
    var icon = ImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    var subtitle = Label().then {
        $0.font = FontsManager.nasalization.font(size: 12)
        $0.numberOfLines = 2
        $0.textColor = .white
    }
    
    override func makeUI() {
        super.makeUI()
        addStackView()
        addTitle()
        addSubtitle()
        self.setNeedsDisplay()
        self.setNeedsLayout()
    }
    
    func addStackView() {
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
    }
    
    func addTitle() {
        stackView.addArrangedSubview(title)
        title.snp.makeConstraints { (make) in
            make.height.equalTo(80)
        }
    }
    
    func addSubtitle() {
        let stack = StackView()
        stack.axis = .horizontal
        
        stackView.addArrangedSubview(stack)
        
        
        stack.addArrangedSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.width.equalTo(30)
        }
        
        stack.addArrangedSubview(subtitle)
        
    }
    
    
}
