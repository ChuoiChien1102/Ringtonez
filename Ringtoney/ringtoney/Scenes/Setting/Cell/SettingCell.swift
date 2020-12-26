//
//  SettingCell.swift
//  ringtoney
//
//  Created by dong ka on 11/5/20.
//

import Foundation

class SettingCell: TableViewCell {
    
    var stackView = StackView().then {
        $0.axis = .horizontal
    }
    
    let indicatorImageView = ImageView().then {
        $0.image = R.image.icon_cell_indicator()
        $0.contentMode = .scaleAspectFit
    }
    
    let titleLabel = Label().then {
        $0.text = "Trending Label"
        $0.font = FontsManager.nasalization.font(size: 14)
        $0.numberOfLines = 1
        $0.textColor = UIColor.init(hexString: "00BB7C")
        $0.textAlignment = .left

    }
    
    let roundView = View().then {
        $0.backgroundColor = UIColor.init(hexString: "252B43")
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        roundView.layer.cornerRadius = 20
        roundView.layer.masksToBounds = true
        roundView.clipsToBounds = true
        
        
    }
    
    override func makeUI() {
        super.makeUI()
        addRoundView()
        addStackView()
        addTitleView()
        addIndicatorView()
    }
    
    func addStackView() {
        
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(32)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }
        
    }
    
    
    func addRoundView() {
        containerView.addSubview(roundView)
        roundView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }
        self.setNeedsDisplay()
        self.setNeedsLayout()
    }
    
    func addTitleView() {
        stackView.addArrangedSubview(titleLabel)
    }
    
    func addIndicatorView() {
        
        let container = View()
        stackView.addArrangedSubview(container)
        container.snp.makeConstraints { (make) in
            make.width.equalTo(20)
        }
        
        container.addSubview(indicatorImageView)
        indicatorImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(12)
        }
        
        
    }
    
    override func bind(to viewModel: TableViewCellViewModel) {
        super.bind(to: viewModel)
        
        guard let viewModel = viewModel as? SettingCellViewModel else { return }
        viewModel.title.bind(to: titleLabel.rx.text).disposed(by: cellDisposeBag)
        
    }

    
}
