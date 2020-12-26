//
//  MakerSoundAdjustView.swift
//  ringtoney
//
//  Created by dong ka on 16/11/2020.
//

import Foundation
class MakerSoundAdjustView: View {
    
    let slowLabel = Label().then {
        $0.text = "Slow"
        $0.font = FontsManager.nasalization.font(size: 14)
        $0.numberOfLines = 1
        $0.textColor = UIColor.init(hexString: "5D6892")
        $0.textAlignment = .center
    }
    
    let fastLabel = Label().then {
        $0.text = "Fast"
        $0.font = FontsManager.nasalization.font(size: 14)
        $0.numberOfLines = 1
        $0.textColor = UIColor.init(hexString: "5D6892")
        $0.textAlignment = .center
    }
    
    let slider = UISlider().then {
        $0.setValue(1.0, animated: true)
        $0.maximumValue = 1.5
        $0.minimumValue = 0.5
        $0.tintColor = UIColor.init(hexString: "00FFAA")
    }
    
    override func makeUI() {
        super.makeUI()
        
        addSubview(slowLabel)
        slowLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
        
        addSubview(fastLabel)
        fastLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
        
        addSubview(slider)
        slider.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
        
    }
        
}
