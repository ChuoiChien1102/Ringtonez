//
//  SettingCellViewModel.swift
//  ringtoney
//
//  Created by dong ka on 11/5/20.
//

import Foundation
class SettingCellViewModel: DefaultTableViewCellViewModel {
    
    var titleString: String
    
    init(titleString: String) {
        self.titleString = titleString
        super.init()
        title.accept(titleString)
    }
    
    
}
