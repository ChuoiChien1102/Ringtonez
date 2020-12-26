//
//  PremiumCViewModel.swift
//  ringtoney
//
//  Created by dong ka on 26/11/2020.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation


class PremiumCViewModel: ViewModel , ViewModelType {
    
    //MARK:- Property
    
    
    //MARK:- Init
    override init() {
        super.init()
    }
    
    //MARK:- Input
    struct Input {
        let dismiss: Observable<Void>
        let weeklyTrigger: Observable<Void>
        let monthyTrigger: Observable<Void>
        let yearlyTrigger: Observable<Void>
        let continueTrigger: Observable<Void>
        let termOfUseTrigger: Observable<Void>
        let privacyTrigger: Observable<Void>
        let restoreTrigger: Observable<Void>
    }
    
    //MARK:- Output
    struct Output {
        let isWeeklySelected: Driver<PremiumChoisedState>
        let price: Driver<TheCPrice>
        let purchaseStatus: Driver<PurchaseStatus?>
    }
    
    //MARK:- Transform
    func transform(input: Input) -> Output {
        
        let premiumChoisedState = BehaviorRelay<PremiumChoisedState>.init(value: .weekly)
        let price = BehaviorRelay<TheCPrice>.init(value: .init())
        let purchaseStatus = BehaviorRelay<PurchaseStatus?>.init(value: nil)
        
        getProductionInfo()
            .observeOn(MainScheduler.instance)
            .bind(to: price)
            .disposed(by: bag)
        
        input.weeklyTrigger
            .map{ PremiumChoisedState.weekly }
            .bind(to: premiumChoisedState)
            .disposed(by: bag)
        
        input.monthyTrigger
            .map{ PremiumChoisedState.monthy }
            .bind(to: premiumChoisedState)
            .disposed(by: bag)
        
        input.yearlyTrigger
            .map{ PremiumChoisedState.yearly }
            .bind(to: premiumChoisedState)
            .disposed(by: bag)
        
        Observable.merge(input.privacyTrigger,input.termOfUseTrigger)
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                guard let coordinator = self.coordinator as? PremiumCCoordinator else { return }
                coordinator.openTermOfUse()
            })
            .disposed(by: bag)
        
        input.dismiss
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                guard let coordinator = self.coordinator as? PremiumCCoordinator else { return }
                coordinator.pop()
            })
            .disposed(by: bag)
        
        input.continueTrigger
            .flatMap { self.continuePurchase(state : premiumChoisedState.value) }
            .subscribe(onNext:{[weak self] _status in
                guard let self = self else { return }
                switch _status {
                case .success:
                    LoadingManager.hide()
                    guard let coordinator = self.coordinator as? PremiumCCoordinator else { return }
                    coordinator.pop()
                    break
                case .error( let msg):
                    LoadingManager.hide()
                    purchaseStatus.accept(.error(msg: msg))
                    break
                }
            })
            .disposed(by: bag)
        
        input.restoreTrigger
            .flatMap { self.restorePurchase()}
            .subscribe(onNext:{[weak self] _status in
                guard let self = self else { return }
                switch _status {
                case .success:
                    LoadingManager.hide()
                    guard let coordinator = self.coordinator as? PremiumCCoordinator else { return }
                    coordinator.pop()
                    break
                case .error( let msg):
                    LoadingManager.hide()
                    purchaseStatus.accept(.error(msg: msg))
                    break
                }
            })
            .disposed(by: bag)
        
        return Output.init(
            isWeeklySelected: premiumChoisedState.asDriver(onErrorJustReturn: .weekly),
            price: price.asDriver(onErrorJustReturn: .init()),
            purchaseStatus: purchaseStatus.asDriver(onErrorJustReturn: nil)
        )
    }
    
    //MARK:- Logic&Functions
    func getProductionInfo() -> Observable<TheCPrice> {
        return Observable.create { (observable) -> Disposable in
            log.debug("Get purchase info")
            var theCPrice: TheCPrice = .init()
            Purchaser.getInfo(ProductIds: [Keys.weekly.appId,Keys.monthy.appId ,Keys.yearly.appId]) { (skProducts) in
                for i in skProducts {
                    if i.productIdentifier == Keys.weekly.appId {
                        theCPrice.weekly = "then \(i.localizedPrice ?? "$x.xx") per week, auto-renewable"
                    }
                    if i.productIdentifier == Keys.monthy.appId {
                        theCPrice.monthy = "then \(i.localizedPrice ?? "$x.xx") per month, auto-renewable"
                    }
                    if i.productIdentifier == Keys.yearly.appId {
                        theCPrice.yearly = "\(i.localizedPrice ?? "$x.xx") per year, auto-renewable"
                    }
                }
                
                log.debug(theCPrice.weekly)
                log.debug(theCPrice.monthy)
                log.debug(theCPrice.yearly)

                observable.onNext(theCPrice)
                observable.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    
    func continuePurchase( state: PremiumChoisedState) -> Observable<PurchaseStatus> {
        return Observable.create { (observable) -> Disposable in
            log.debug("Purchase a product")
            var productToPurchase = ""
            switch state {
            case .weekly: productToPurchase = Keys.weekly.appId
                case .monthy: productToPurchase = Keys.monthy.appId
                case .yearly: productToPurchase = Keys.yearly.appId
            }
            Purchaser.purchaseAProduct(productID: productToPurchase) {
                observable.onNext(.success)
                observable.onCompleted()
            } failure: { (str) in
                observable.onNext(.error(msg: str ?? "UNKNOW ERROR"))
                observable.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func restorePurchase() -> Observable<PurchaseStatus> {
        return Observable.create { (observable) -> Disposable in
            Purchaser.restorePurchase {
                observable.onNext(.success)
                observable.onCompleted()
            } failure: { (msg) in
                observable.onNext(.error(msg: msg ?? "UNKNOW ERROR"))
                observable.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    
}

