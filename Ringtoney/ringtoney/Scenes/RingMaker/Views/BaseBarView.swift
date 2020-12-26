//
//  BaseBarView.swift
//  ringtoney
//
//  Created by dong ka on 14/11/2020.
//

import Foundation
import SnapKit

protocol BarView: class {
    var bgColor: UIColor { get set }
    var lineColor: UIColor { get set }
    var thumbColor: UIColor { get set }
}

class BaseBarView : View, BarView {
    
    var bgColor: UIColor = .red {
        didSet {
            self.backgroundColor = bgColor
        }
    }
    
    var lineColor: UIColor = UIColor.init(hexString: "00FFAA")
    var thumbColor: UIColor = .white
    
    var thumb = View()
    
    //Middlelive
    var line = View()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundView(v: thumb)
    }
    
    override func makeUI() {
        super.makeUI()
        
        self.backgroundColor = bgColor
        
        addMiddleLine()
        addThumb()
    }
    
    func addMiddleLine() {
        self.addSubview(line)
        line.backgroundColor = lineColor
        line.snp.makeConstraints { (make) in
            make.width.equalTo(2)
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    func addThumb() {
        self.addSubview(thumb)
        thumb.backgroundColor = thumbColor
        thumb.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.lessThanOrEqualTo(30)
        }
    }
    
    func roundView(v: View) {
        v.layer.cornerRadius = 15
        v.layer.masksToBounds = true
    }
    
}
