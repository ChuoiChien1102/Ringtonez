//
//  HomeBaseView.swift
//  ringtoney
//
//  Created by dong ka on 11/2/20.
//

import Foundation
class HomeBaseView : View {
    
    var thumbImageView = ImageView().then {
        $0.image = R.image.img_ringtone_maker_thumb()
        $0.contentMode = .scaleAspectFill
    }
    
    var backgroundImageView = ImageView().then {
        $0.image = R.image.img_ringtone_maker()
        $0.contentMode = .scaleAspectFill
    }
    
    var infoView = HomeInfoView()
    
    var stackView = StackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.thumbImageView.layer.cornerRadius = 18
        self.thumbImageView.layer.masksToBounds = true
        
        self.backgroundImageView.layer.cornerRadius = 18
        self.backgroundImageView.layer.masksToBounds = true
    }

    override func makeUI() {
        super.makeUI()
        addBackgroundImageView()
        addStackView()
        addMaskViewForIpad()
    }
    
    func addStackView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(28)
            make.top.bottom.equalToSuperview()
        }
    }
    
    func addMaskViewForIpad() {
//        if DNDeviceManager.isIpad() {
//            let container = View()
//            stackView.addArrangedSubview(Spacer())
//            stackView.addArrangedSubview(container)
//            stackView.addArrangedSubview(Spacer())
//
//            stackView.distribution = .fill
//            stackView.axis = .horizontal
//
//            container.snp.makeConstraints { (make) in
//                make.width.equalTo(500)
//            }
//
//            let stack = StackView()
//            stack.axis = .horizontal
//            stack.distribution = .fill
//
//            container.addSubview(stack)
//            stack.snp.makeConstraints { (make) in
//                make.edges.equalToSuperview()
//            }
//
//            addIntroView(stack)
//            addThumbImageView(stack)
//
//            self.setNeedsDisplay()
//            self.setNeedsLayout()
//        } else {
            addIntroView(stackView)
            addThumbImageView(stackView)
            self.setNeedsDisplay()
            self.setNeedsLayout()
//        }
    }
    
    func addBackgroundImageView () {
        
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(28)
            make.top.bottom.equalToSuperview()
        }
    }
 
    func addIntroView(_ st: StackView) {
        
        let container = View()
        container.backgroundColor = .clear
        st.addArrangedSubview(container)
        
        container.addSubview(infoView)
        
        infoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    func addThumbImageView(_ st: StackView) {
        st.insertArrangedSubview(thumbImageView, at: 0)
        thumbImageView.snp.makeConstraints { (make) in
            make.width.equalTo(160)
        }
    }
    
}
