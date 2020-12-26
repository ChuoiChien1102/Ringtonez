//
//  BaseBarView.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 11/24/20.
//

import Foundation
import SnapKit

class BaseBarView : View {
    
    var line = View()
    var imageView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func makeUI() {
        super.makeUI()
        addComponent()
    }
    
    func addComponent() {
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.width.equalTo(10)
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(6)
            make.height.equalTo(12)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
}
