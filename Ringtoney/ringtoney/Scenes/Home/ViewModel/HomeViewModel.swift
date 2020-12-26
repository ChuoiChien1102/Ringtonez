//
//  HomeViewModel.swift
//  ringtoney
//
//  Created by dong ka on 10/29/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation


class HomeViewModel: ViewModel , ViewModelType {
    
    //MARK:- Property
    

    //MARK:- Init
    override init() {
        super.init()
    }
    
    //MARK:- Input
    struct Input {
        let ringmakerTrigger: Observable<URL>
        let premiumTrigger: Observable<Void>
    }
    
    //MARK:- Output
    struct Output {
        
    }
    
    //MARK:- Transform
    func transform(input: Input) -> Output {
        
        input.premiumTrigger
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                guard let coordinator = self.coordinator as? HomeCoordinator else { return }
                coordinator.openPremiumB()
            })
            .disposed(by: bag)
        
        input.ringmakerTrigger
            .subscribe(onNext:{[weak self] audioURL in
                guard let self = self else { return }
                guard let coordinator = self.coordinator as? HomeCoordinator else { return }
                coordinator.openRingMaker(audioURL: audioURL)
            })
            .disposed(by: bag)
                        
        return Output.init()
    }
    
    //MARK:- Logic&Functions

    
    
    
}
