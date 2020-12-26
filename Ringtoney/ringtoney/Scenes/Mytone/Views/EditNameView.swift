//
//  EditNameView.swift
//  ringtoney
//
//  Created by dong ka on 21/11/2020.
//

import Foundation
import SnapKit


class EditNameView: View {
    
    let titleLabel = Label().then {
        $0.text = "Rename"
        $0.font = FontsManager.nasalization.font(size: 17)
        $0.numberOfLines = 1
        $0.textColor = UIColor.init(hexString: "002417")
        $0.textAlignment = .center
    }
    
    let cancelButton = Button().then {
        $0.setTitle("Cancel", for: .normal)
        $0.setTitleColor(UIColor.init(hexString: "002417"), for: .normal)
    }
    
    let submitButton = Button().then {
        $0.setTitle("Submit", for: .normal)
        $0.setTitleColor(UIColor.init(hexString: "002417"), for: .normal)
    }
    
    let textField = UITextField().then {
        $0.placeholder = "Ener your new ringtone name"
    }
    
    let contentContainerView = View().then {
        $0.backgroundColor = .white
    }
    
    let stackView = StackView().then {
        $0.axis = .vertical
    }
    
    let backgroundView = View()
    
    private let footerStackView = StackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    
    var ringtone: Ringtone!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentContainerView.layer.cornerRadius = 12
        contentContainerView.layer.masksToBounds = true
        
    }
    
    override func makeUI() {
        super.makeUI()
        
        self.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        addContentContainerView()
        addStackView()
        
        addTitleLabel()
        addTextField()
        
        addFooterStackView()
    }
    
    func addContentContainerView() {
        self.addSubview(contentContainerView)
        contentContainerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(320)
            make.height.equalTo(200)
        }
    }
    
    func addStackView() {
        contentContainerView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(8)
        }
    }
    
    func addTitleLabel() {
        stackView.addArrangedSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
    }
    
    func addTextField() {
        let container = View()
        stackView.addArrangedSubview(container)
        
        container.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func addFooterStackView() {
        stackView.addArrangedSubview(footerStackView)
        footerStackView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
        addSubmitButton()
        addCancelButton()
    }
    
    func addSubmitButton() {
        footerStackView.addArrangedSubview(cancelButton)
    }
    
    func addCancelButton() {
        footerStackView.addArrangedSubview(submitButton)
    }
    
    //Animate
    func show(Target ringtone: Ringtone) {
        
        self.ringtone = ringtone
        self.textField.text = ringtone.name
        
        self.alpha = 0
        self.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        backgroundView.alpha = 0
 
        UIView.animate(withDuration: 0.4) {
            self.transform = .identity
            self.alpha = 1
            self.setNeedsDisplay()
        } completion: { (success) in
            UIView.animate(withDuration: 0.3) {
                self.backgroundView.alpha = 1
            }
        }

        

        
    }
    
    func hide(animate: Bool) {
        if animate {
            self.backgroundView.alpha = 0
            self.alpha = 1
            UIView.animate(withDuration: 0.3) {
                self.alpha = 0
                self.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                self.setNeedsDisplay()
            }

        } else {
            self.alpha = 0
            self.backgroundView.alpha = 0
            self.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            self.setNeedsDisplay()
        }
    }
    
}
