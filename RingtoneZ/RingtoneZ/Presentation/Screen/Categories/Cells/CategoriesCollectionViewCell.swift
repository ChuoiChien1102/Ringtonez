//
//  CategoriesCollectionViewCell.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 11/9/20.
//

import UIKit
import Kingfisher

class CategoriesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewIcon: UIView!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configUI(category: CategoryModel) -> Void {
        viewIcon.layer.cornerRadius = viewIcon.frame.height/5
        icon.layer.cornerRadius = icon.frame.height/5
        if category.iconURL != nil {
            icon.kf.setImage(with:category.iconURL)
        }
        lbContent.text = category.name
    }
}
