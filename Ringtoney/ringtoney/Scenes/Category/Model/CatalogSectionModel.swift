//
//  CatalogSectionModel.swift
//  ringtoney
//
//  Created by dong ka on 11/3/20.
//

import Foundation

enum CatalogSectionItem {
    case trend(CatalogTopCategoryCellViewModel)
    case category(CatalogCellViewModel)
}

enum CatalogSectionModel {
    case topCategoriesSection(title: String,
                       items: [CatalogSectionItem])
    case genresSection(title: String,
                items: [CatalogSectionItem])
}

extension CatalogSectionModel: SectionModelType {
    
    typealias Item = CatalogSectionItem

    var items: [CatalogSectionItem] {
        switch  self {
        case .topCategoriesSection(title: _, items: let items):
            return items.map { $0 }
        case .genresSection(title: _, items: let items):
            return items.map { $0 }
        }
    }
    
    var title: String {
        switch self {
        case .topCategoriesSection(title: let title, items: _):
            return title
        case .genresSection(title: let title, items: _):
            return title
        }
    }
    
    init(original: CatalogSectionModel, items: [Item]) {
        switch original {
        case .topCategoriesSection(title: let title, items: let items):
            self = .topCategoriesSection(title: title, items: items)
        case .genresSection(title: let title, items: let items):
            self = .genresSection(title: title, items: items)
        }
    }
}

