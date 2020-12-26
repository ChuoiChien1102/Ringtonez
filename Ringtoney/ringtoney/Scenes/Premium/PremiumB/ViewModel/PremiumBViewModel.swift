//
//  PremiumBViewModel.swift
//  ringtoney
//
//  Created by dong ka on 26/11/2020.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation


class PremiumBViewModel: ViewModel , ViewModelType {
    
    //MARK:- Property
    

    //MARK:- Init
    override init() {
        super.init()
    }
    
    //MARK:- Input
    struct Input {
        let dismiss: Observable<Void>
        let continueTrigger: Observable<Void>
        let termOfUseTrigger: Observable<Void>
        let privacyTrigger: Observable<Void>
        let restoreTrigger: Observable<Void>
    }
    
    //MARK:- Output
    struct Output {
        let price: Driver<String>
        let purchaseStatus: Driver<PurchaseStatus?>
    }
    
    //MARK:- Transform
    func transform(input: Input) -> Output {
        
        let price = BehaviorRelay<String>.init(value: "then $4.99 per week, auto-renewable")
        let purchaseStatus = BehaviorRelay<PurchaseStatus?>.init(value: nil)
        
        input.dismiss
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                guard let coordinator = self.coordinator as? PremiumBCoordinator else { return }
                coordinator.pop()
            })
            .disposed(by: bag)
        
        getProductionInfo()
            .subscribeOn(MainScheduler.instance)
            .bind(to: price)
            .disposed(by: bag)
        
        Observable.merge(input.privacyTrigger,input.termOfUseTrigger)
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                guard let coordinator = self.coordinator as? PremiumBCoordinator else { return }
                coordinator.openTermOfUse()
            })
            .disposed(by: bag)
        
        input.continueTrigger
            .subscribeOn(MainScheduler.instance)
            .flatMap { self.continuePurchase()}
            .subscribe(onNext:{[weak self] _status in
                guard let self = self else { return }
                switch _status {
                case .success:
                    LoadingManager.hide()

                    guard let coordinator = self.coordinator as? PremiumBCoordinator else { return }
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
            .subscribeOn(MainScheduler.instance)
            .flatMap { self.restorePurchase()}
            .subscribe(onNext:{[weak self] _status in
                guard let self = self else { return }
                switch _status {
                case .success:
                    LoadingManager.hide()

                    guard let coordinator = self.coordinator as? PremiumBCoordinator else { return }
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
            price: price.asDriver(onErrorJustReturn: "then $4.99 per week, auto-renewable"),
            purchaseStatus: purchaseStatus.asDriver(onErrorJustReturn: nil)

        )
    }
    
    //MARK:- Logic&Functions
    
    func getProductionInfo() -> Observable<String> {
        return Observable.create { (observable) -> Disposable in
            log.debug("Get purchase info")
            Purchaser.getInfo(ProductIds: [Keys.weekly.appId]) { (skProducts) in
                for i in skProducts {
                    if i.productIdentifier == Keys.weekly.appId {
                        observable.onNext("then \(i.localizedPrice ?? "$x.xx")  per week, auto-renewable")
                        observable.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }

    func continuePurchase() -> Observable<PurchaseStatus> {
        return Observable.create { (observable) -> Disposable in
            log.debug("Purchase a product")
            let productToPurchase = Keys.weekly.appId
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

