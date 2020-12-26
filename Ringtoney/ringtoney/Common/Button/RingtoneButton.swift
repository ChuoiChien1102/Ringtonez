//
//  RingtoneButton.swift
//  ringtoney
//
//  Created by dong ka on 11/5/20.
//

import Foundation

class RingtoneButton: Button {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.masksToBounds = true
    }
    
    func makeUI() {
        self.setTitleColor(UIColor.init(hexString: "002417"), for: .normal)
        self.titleLabel?.font = FontsManager.nasalization.font(size: 17)
        self.titleLabel?.numberOfLines = 1
        self.titleLabel?.textAlignment = .center
        self.backgroundColor = UIColor.init(hexString: "FFFFFF")
    }
    
    func updateBackgroundColor( _isSelected: Bool ){
        
        self.setUIButton()
        
        if _isSelected {
            self.backgroundColor = UIColor.init(hexString: "00FFAA")
            self.layer.shadowColor = UIColor.init(hexString: "00FFAA")!.cgColor

        } else {
            self.backgroundColor = .white
            self.layer.shadowColor = UIColor.clear.cgColor

        }
        
        
    }
    
    //Round button
    func setUIButton() {
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = true
        
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.29
        self.layer.shadowRadius = 20
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.clear.cgColor

    }

        
}
