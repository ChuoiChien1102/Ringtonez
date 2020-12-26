//
//  IntroAViewModel.swift
//  ringtoney
//
//  Created by dong ka on 28/11/2020.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation


class IntroAViewModel: ViewModel , ViewModelType {
    
    //MARK:- Property
    

    //MARK:- Init
    override init() {
        super.init()
    }
    
    //MARK:- Input
    struct Input {
        let continueTrigger: Observable<Void>
    }
    
    //MARK:- Output
    struct Output {
       
    }
    
    //MARK:- Transform
    func transform(input: Input) -> Output {
        
        input.continueTrigger
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                guard let coordinator = self.coordinator as? IntroACoordinator else { return }
                coordinator.openIntroB()
            })
            .disposed(by: bag)
        
        
        return Output.init()
    }
    
    //MARK:- Logic&Functions
    
    
    
    
}

