//
//  TutorialCell.swift
//  ringtoney
//
//  Created by dong ka on 03/12/2020.
//

import Foundation
class TutorialCell: CollectionViewCell {
    
    let stackView = StackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    let imageView = ImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    override func makeUI() {
        super.makeUI()
        addStackView()
        addImageView()
    }
    
    
    func addStackView() {
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func addImageView() {
        stackView.addArrangedSubview(imageView)
    }
    
    
}
