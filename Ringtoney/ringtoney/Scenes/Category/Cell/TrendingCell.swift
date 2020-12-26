//
//  TrendingCell.swift
//  ringtoney
//
//  Created by dong ka on 11/5/20.
//

import Foundation
class TrendingCell: CollectionViewCell {
    
    var selectedTextHexColor = "002417"
    var selectedBackgroundHexColor = "00FFAA"
    var unselectedBackgroundHexColor = "FFFFFF"
    
    let titleLabel = Label().then {
        $0.text = "Trending Label"
        $0.font = FontsManager.nasalization.font(size: 17)
        $0.numberOfLines = 1
        $0.textColor = UIColor.init(hexString: "002417")
        $0.textAlignment = .center
    }
    
    override func makeUI() {
        super.makeUI()
        addTitleLabel()
    }
    
    override func updateUI() {
        super.updateUI()
        
        backgroundColor = .white
        
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.masksToBounds = true
    }
    
    func addTitleLabel() {
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    
}
