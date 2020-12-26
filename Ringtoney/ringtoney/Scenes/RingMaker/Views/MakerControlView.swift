//
//  MakerControlView.swift
//  ringtoney
//
//  Created by dong ka on 16/11/2020.
//

import Foundation
class MakerControlView: View {
    
    var playButton = Button().then {
        $0.setImage(R.image.icon_button_play(), for: .normal)
        $0.setImage(R.image.icon_button_pause(), for: .selected)

    }
    
    var tutorialButton = Button().then {
        $0.setTitle("Tutorial", for: .normal)
        $0.backgroundColor = UIColor.init(hexString: "252B43")
        $0.titleLabel?.font = FontsManager.nasalization.font(size: 13)
        $0.setTitleColor(.white, for: .normal)
    }
    
    var saveButton = Button().then {
        $0.setTitle("Save", for: .normal)
        $0.backgroundColor = UIColor.init(hexString: "252B43")
        $0.titleLabel?.font = FontsManager.nasalization.font(size: 13)
        $0.setTitleColor(.white, for: .normal)
    }
    
    override func makeUI() {
        super.makeUI()
        
        self.addSubview(playButton)
        playButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(90)
        }
        
        self.addSubview(tutorialButton)
        tutorialButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(23)
            make.height.equalTo(40)
            make.width.equalTo(100)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(23)
            make.height.equalTo(40)
            make.width.equalTo(100)
            make.centerY.equalToSuperview()
        }
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUIButton(btn: saveButton)
        setUIButton(btn: tutorialButton)
    }
    
    
    //Round button
    func setUIButton(btn: Button) {
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
    }
    
}
