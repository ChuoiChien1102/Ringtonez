//
//  HomeCatelogView.swift
//  ringtoney
//
//  Created by dong ka on 11/2/20.
//

import Foundation

class HomeCatelogView : HomeBaseView {
    
    override func makeUI() {
        super.makeUI()
        
        thumbImageView.image = R.image.img_ringtone_catalog_thumb()
        backgroundImageView.image = R.image.img_ringtone_catalog()
        
        infoView.title.text = "Ringtone\n Catalog"
        infoView.subtitle.text = "500+ treding\n ringtones"
        infoView.icon.image = R.image.icon_ringtone_catalog()

    }
    
    override func addThumbImageView(_ st: StackView) {
        st.insertArrangedSubview(thumbImageView, at: 1)
        thumbImageView.snp.makeConstraints { (make) in
            make.width.equalTo(160)
        }
    }
    
    
}
