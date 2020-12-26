//
//  PCButton.swift
//  ringtoney
//
//  Created by dong ka on 25/11/2020.
//

import Foundation
class PCButton: View {
    
    var isSelected: Bool = true
    
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
    
    let tagView = PTagView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
      
        if isSelected {
            applyShadowWithCornerRadius(color: UIColor.init(hexString: "00FFAA")!,
                                        opacity: 0.29,
                                        radius: 19,
                                        edge: .All,
                                        shadowSpace: 19)
        }
        else {
            applyShadowWithCornerRadius(color: UIColor.init(hexString: "00FFAA")!,
                                        opacity: 0,
                                        radius: 19,
                                        edge: .All,
                                        shadowSpace: 19)
        }
        
        
    }
    
    override func makeUI() {
        super.makeUI()
        addStackView()
        addDescLabel()
        addTitleLabel()
        addTagView()
        setSelected(false)
    }
    
    func addStackView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(8)
        }
        stackView.clipsToBounds = false
        stackView.layer.masksToBounds = false
    }
    
    func addTitleLabel() {
        stackView.addArrangedSubview(titleLabel)
    }
    
    func addDescLabel() {
        stackView.addArrangedSubview(descLabel)
    }
    
    func addTagView() {
        self.addSubview(tagView)
        tagView.snp.makeConstraints { (make) in
            make.top.trailing.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(65)
        }
    }
    
    func setSelected( _ value: Bool ) {
        
        self.isSelected = value
        
        if value {
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.clear.cgColor
            self.backgroundColor = UIColor.init(hexString: "00FFAA")
            self.titleLabel.textColor = UIColor.init(hexString: "002417")
            self.descLabel.textColor = UIColor.init(hexString: "002417")

        }
        else {
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.white.cgColor
            self.backgroundColor = .clear
            self.titleLabel.textColor = UIColor.init(hexString: "FFFFFF")
            self.descLabel.textColor = UIColor.init(hexString: "FFFFFF")

        }
        
        self.layoutSubviews()
        self.setNeedsDisplay()

    }
    
}
