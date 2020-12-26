//
//  DefaultRingtoneCell.swift
//  ringtoney
//
//  Created by dong ka on 11/7/20.
//

import Foundation

class DefaultRingtoneCell : TableViewCell {
    
    let stackView = StackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
    }
    
    let playButton = Button().then {
        $0.setImage(R.image.icon_cell_play(), for: .normal)
        $0.setImage(R.image.icon_cell_pause(), for: .selected)
    }
    
    let moreButton = Button().then {
        $0.setImage(R.image.icon_cell_more(), for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: -8)
    }
    
    let titleLabel = Label().then {
        $0.text = "Ringtone name"
        $0.font = FontsManager.nasalization.font(size: 15)
        $0.numberOfLines = 1
        $0.textColor = UIColor.init(hexString: "FFFFFF")
        $0.textAlignment = .left
    }
    
    var progressView = View().then {
        $0.backgroundColor = .red
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        progressView.layoutIfNeeded()
        let gradientColor = UIColor.init(gradientStyle: .leftToRight,
                                         withFrame: progressView.frame,
                                         andColors: [
                                            UIColor.init(hexString: "00F3F8")!,
                                            UIColor.init(hexString: "2222FF")!,
                                            UIColor.init(hexString: "9300FE")!,
                                            UIColor.init(hexString: "F778AE")!
                                         ])
        
        progressView.backgroundColor = gradientColor
        
    }
    
    override func makeUI() {
        super.makeUI()
        addStackView()
        addPlayButton()
        addTitleLabel()
        addMoreButton()
        addProgressView()
        
//        self.layoutIfNeeded()
//        self.setNeedsDisplay()
    }
    
    func addStackView() {
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    func addPlayButton() {
        stackView.addArrangedSubview(playButton)
        playButton.snp.makeConstraints { (make) in
            make.width.equalTo(52)
        }
    }
    
    func addTitleLabel() {
        stackView.addArrangedSubview(titleLabel)
    }
    
    func addMoreButton() {
        stackView.addArrangedSubview(moreButton)
        moreButton.snp.makeConstraints { (make) in
            make.width.equalTo(52)
        }
    }
    
    func addProgressView() {
        
        contentView.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(12)
            make.height.equalTo(2)
            make.leading.equalToSuperview().offset(84)
            make.width.equalTo(1)
        }
        
    }
    
}
