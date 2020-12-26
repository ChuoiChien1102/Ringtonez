//
//  BootViewModel.swift
//  ringtoney
//
//  Created by dong ka on 28/11/2020.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation


class BootViewModel: ViewModel , ViewModelType {
    
    //MARK:- Property
    

    //MARK:- Init
    override init() {
        super.init()
        
        
        if Defaults[\.launchCount] <= 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard let coordinator = self.coordinator as? BootCoordinator else { return }
                coordinator.openIntroA()
            }
        } else {
            if Defaults[\.isPurchased] {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    guard let coordinator = self.coordinator as? BootCoordinator else { return }
                    coordinator.openMain()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    guard let coordinator = self.coordinator as? BootCoordinator else { return }
                    coordinator.openPremium()
                }
            }

        }
        
        
    }
    
    //MARK:- Input
    struct Input {
        
    }
    
    //MARK:- Output
    struct Output {
       
    }
    
    //MARK:- Transform
    func transform(input: Input) -> Output {
        
        return Output.init()
    }
    
    //MARK:- Logic&Functions
    
    
    
    
}

