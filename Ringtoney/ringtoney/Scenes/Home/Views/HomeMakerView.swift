//
//  HomeMakerView.swift
//  ringtoney
//
//  Created by dong ka on 11/2/20.
//

import Foundation

class HomeMakerView : HomeBaseView {
    
    override func makeUI() {
        super.makeUI()
        
        thumbImageView.image = R.image.img_ringtone_maker_thumb()
        backgroundImageView.image = R.image.img_ringtone_maker()
        
        infoView.title.text = "Ringtone\n Maker"
        infoView.subtitle.text = "record and\n edit ringtones"

        infoView.icon.image = R.image.icon_ringtone_maker()
        
    }

    
}
