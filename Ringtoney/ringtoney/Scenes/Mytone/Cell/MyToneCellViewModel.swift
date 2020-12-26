//
//  MyToneCellViewModel.swift
//  ringtoney
//
//  Created by dong ka on 19/11/2020.
//

import Foundation
class MyToneCellViewModel: DefaultTableViewCellViewModel {
    
    var ringtone: Ringtone
    var isPlay = BehaviorRelay<Bool>.init(value: false)
    var progress = BehaviorRelay<Double>.init(value: 0)
    
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
