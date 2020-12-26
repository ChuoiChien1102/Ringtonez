//
//  SettingViewModel.swift
//  ringtoney
//
//  Created by dong ka on 11/2/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation


class SettingViewModel: ViewModel , ViewModelType {
    
    //MARK:- Property
    

    //MARK:- Init
    override init() {
        super.init()
    }
    
    //MARK:- Input
    struct Input {
        let trigger: Observable<Void>
        let selection: Observable<IndexPath>
        let premiumTrigger: Observable<Void>

    }
    
    //MARK:- Output
    struct Output {
        let items: Driver<[SettingSectionModel]>
//        let openTermAndPrivacy: Observable<String?>
        let openRating: Observable<Void>
        let sendEmail: Observable<Void>
        let shareApp: Observable<Void>
        
    }
    
    //MARK:- Transform
    func transform(input: Input) -> Output {
        
        let elements = BehaviorRelay<[SettingSectionModel]>.init(value: [])
        let refresh = Observable.of(input.trigger).merge()
                
        let openRating = PublishSubject<Void>.init()
        let sendEmail = PublishSubject<Void>.init()
        let shareApp = PublishSubject<Void>.init()

        input.selection
            .filter{$0.row == 0 && $0.section == 0}
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                guard let coordinator = self.coordinator as? SettingCoordinator else { return }
                coordinator.openTutorial()
            })
            .disposed(by: bag)
        
        input.selection
            .filter{$0.row == 0 && $0.section == 1}
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                guard let coordinator = self.coordinator as? SettingCoordinator else { return }
                coordinator.openTermOfUse()
            })
            .disposed(by: bag)
        
        input.selection
            .filter{$0.row == 1 && $0.section == 1}
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                guard let coordinator = self.coordinator as? SettingCoordinator else { return }
                coordinator.openTermOfUse()
            })
            .disposed(by: bag)
        
        input.selection
            .filter{$0.row == 2 && $0.section == 1}
            .map { _ in return Void() }
            .bind(to: openRating)
            .disposed(by: bag)
        
        input.selection
            .filter{$0.row == 3 && $0.section == 1}
            .map { _ in return Void() }
            .bind(to: sendEmail)
            .disposed(by: bag)
        
        input.selection
            .filter{$0.row == 4 && $0.section == 1}
            .map { _ in return Void() }
            .bind(to: shareApp)
            .disposed(by: bag)
        
        refresh.map { [weak self] _ -> [SettingSectionModel] in
            
            guard let self = self else { return [] }
            var items: [SettingSectionModel] = []
            
            let topCategoriesSection =
                SettingSectionModel.tutorial(
                    title: "Tutorial",
                    items: [
                        //SettingSectionItem.base(.init(titleString: "Install ringtone via Garaband")),
                        SettingSectionItem.base(.init(titleString: "Install ringtone via itunes"))
                    ])
            
            let genresSection =
                SettingSectionModel.general(
                    title: "General",
                    items: [
                        SettingSectionItem.base(.init(titleString: "Privacy policy")),
                        SettingSectionItem.base(.init(titleString: "Term of use")),
                        SettingSectionItem.base(.init(titleString: "Rate & Review the app!")),
                        SettingSectionItem.base(.init(titleString: "Contact us!")),
                        SettingSectionItem.base(.init(titleString: "Tell Friends"))
                    ])
            
            items += [
                topCategoriesSection,
                genresSection
            ]
            
            return items
        }
        .bind(to: elements)
        .disposed(by: bag)
        
        input.premiumTrigger
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                guard let coordinator = self.coordinator as? SettingCoordinator else { return }
                coordinator.openPremium()
            })
            .disposed(by: bag)
                
        return Output.init(
            items: elements.asDriver(onErrorJustReturn: []),
//            openTermAndPrivacy: openTerm.asObserver(),
            openRating: openRating.asObserver(),
            sendEmail: sendEmail.asObserver(),
            shareApp: shareApp.asObserver()
        )
    }
    
    //MARK:- Logic&Functions
    
    
}

