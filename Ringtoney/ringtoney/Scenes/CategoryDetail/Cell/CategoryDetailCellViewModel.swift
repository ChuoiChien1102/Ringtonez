//
//  CategoryDetailCellViewModel.swift
//  ringtoney
//
//  Created by dong ka on 22/11/2020.
//

import Foundation

class CategoryDetailCellViewModel: DefaultTableViewCellViewModel {
    
    var ringtone: Ringtone
    var isPlay = BehaviorRelay<Bool>.init(value: false)
    var progress = BehaviorRelay<Double>.init(value: 0)
    
    var isDownloaded = BehaviorRelay<Bool>.init(value: false)
    
    init(ringtone: Ringtone) {
        self.ringtone = ringtone
        super.init()
        
        title.accept(ringtone.name)
        ringtone.onChangeValue = {[weak self] value in
            guard let self = self else { return }
            self.progress.accept(value)
        }
    }
    
    
}
