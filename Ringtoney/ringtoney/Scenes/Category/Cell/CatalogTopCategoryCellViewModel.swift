//
//  CatalogTopCategoryCellViewModel.swift
//  ringtoney
//
//  Created by dong ka on 11/3/20.
//

import Foundation

class CatalogTopCategoryCellViewModel: DefaultTableViewCellViewModel {
    
    var trending: Trending
    let categories = BehaviorRelay<[Category]>(value: [])
    
    let selectedCategories = BehaviorRelay<Category?>.init(value: nil)
    
    init(trending: Trending) {
        self.trending = trending
        super.init()
        self.categories.accept(trending.categories)
    }
        
}
