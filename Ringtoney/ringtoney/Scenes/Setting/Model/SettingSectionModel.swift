//
//  SettingSectionModel.swift
//  ringtoney
//
//  Created by dong ka on 11/6/20.
//

import Foundation
enum SettingSectionItem {
    case base(SettingCellViewModel)
}

enum SettingSectionModel {
    case tutorial(title: String,
                       items: [SettingSectionItem])
    case general(title: String,
                items: [SettingSectionItem])
}

extension SettingSectionModel: SectionModelType {
    
    typealias Item = SettingSectionItem

    var items: [SettingSectionItem] {
        switch  self {
        case .tutorial(title: _, items: let items):
            return items.map { $0 }
        case .general(title: _, items: let items):
            return items.map { $0 }
        }
    }
    
    var title: String {
        switch self {
        case .tutorial(title: let title, items: _):
            return title
        case .general(title: let title, items: _):
            return title
        }
    }
    
    init(original: SettingSectionModel, items: [Item]) {
        switch original {
        case .tutorial(title: let title, items: let items):
            self = .tutorial(title: title, items: items)
        case .general(title: let title, items: let items):
            self = .general(title: title, items: items)
        }
    }
}

