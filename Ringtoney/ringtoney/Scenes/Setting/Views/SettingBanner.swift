//
//  SettingBanner.swift
//  ringtoney
//
//  Created by dong ka on 11/6/20.
//

import Foundation
class SettingBanner: View {
    
    var roundView = View().then {
        $0.backgroundColor = UIColor.init(hexString: "151824")
    }
    
    let icon = ImageView().then {
        $0.image = R.image.icon_setting_premium()
        $0.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundView.layer.cornerRadius = 12
        roundView.layer.masksToBounds = true
    }
    
    override func makeUI() {
        super.makeUI()
        addRoundView()
        addIconPremium()
    }
    
    private func addRoundView() {
        self.addSubview(roundView)
        roundView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(14)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    func addIconPremium() {
        self.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(114)
            make.height.equalTo(26)
        }
    }
    
}
