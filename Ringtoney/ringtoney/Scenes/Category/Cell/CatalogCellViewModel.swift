//
//  CatalogCellViewModel.swift
//  ringtoney
//
//  Created by dong ka on 11/3/20.
//

import Foundation

class CatalogCellViewModel: DefaultTableViewCellViewModel {
    
    var category: Category
    
    init(category: Category) {
        self.category = category
        super.init()
        self.title.accept(category.title)
    }
    
    
}
