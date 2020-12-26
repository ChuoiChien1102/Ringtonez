//
//  TutorialViewModel.swift
//  ringtoney
//
//  Created by dong ka on 03/12/2020.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation


class TutorialViewModel: ViewModel , ViewModelType {
    
    //MARK:- Property
    

    //MARK:- Init
    override init() {
        super.init()
    }
    
    //MARK:- Input
    struct Input {
        let dismiss: Observable<Void>
    }
    
    //MARK:- Output
    struct Output {
        let items: Driver<[TutorialModel]>
    }
    
    //MARK:- Transform
    func transform(input: Input) -> Output {
        
        let elements = BehaviorRelay<[TutorialModel]>.init(value: [])
        
        fetchDatas()
            .bind(to: elements)
            .disposed(by: bag)
        
        input.dismiss
            .subscribe(onNext:{_ in
                guard let coordinator = self.coordinator as? TutorialCoordinator else { return }
                coordinator.pop()
            })
            .disposed(by: bag)
        
        return Output.init(
            items: elements.asDriver(onErrorJustReturn: [])
        )
    }
    
    //MARK:- Logic&Functions
    func fetchDatas() -> Observable<[TutorialModel]> {
        return Observable.create { (observable) -> Disposable in
            //code here
            //do something
            
            var models: [TutorialModel] = []
            
            for i in 1 ... 6 {
                models.append(TutorialModel.init(image: UIImage.init(named: "t\(i)")))
            }
            
            observable.onNext(models)
            observable.onCompleted()
            return Disposables.create()
        }
    }

    
    
    
}

