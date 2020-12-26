//
//  RecordControlView.swift
//  ringtoney
//
//  Created by dong ka on 11/10/20.
//

import Foundation
class RecordControlView: View {
    
    let playButton = Button().then {
        $0.setImage(R.image.icon_button_pause(), for: .selected)
        $0.setImage(R.image.icon_button_play(), for: .normal)
    }
    
    let makerButton = Button().then {
        $0.setTitle("Maker", for: .normal)
        $0.backgroundColor = UIColor.init(hexString: "252B43")
        $0.titleLabel?.font = FontsManager.nasalization.font(size: 13)
        $0.setTitleColor(.white, for: .normal)
    }
    
    let saveButton = Button().then {
        $0.setTitle("Save", for: .normal)
        $0.backgroundColor = UIColor.init(hexString: "252B43")
        $0.titleLabel?.font = FontsManager.nasalization.font(size: 13)
        $0.setTitleColor(.white, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makerButton.layer.cornerRadius = 20
        makerButton.layer.masksToBounds = true
        saveButton.layer.cornerRadius = 20
        saveButton.layer.masksToBounds = true
    }
    
    override func makeUI() {
        super.makeUI()
        
        addSubview(playButton)
        playButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        addSubview(makerButton)
        makerButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        addSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
    }
    
    
    
}
