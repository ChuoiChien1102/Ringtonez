//
//  PremiumAViewModel.swift
//  ringtoney
//
//  Created by dong ka on 26/11/2020.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation


class PremiumAViewModel: ViewModel , ViewModelType {
    
    //MARK:- Property
    //var timer: Timer?
    //var counter = BehaviorRelay<Int>.init(value: Defaults[\.flashSaleCounter])

    //MARK:- Init
    override init() {
        super.init()
        //startTimer()
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
        let countDown: Driver<String>
        let price: Driver<String>
        let purchaseStatus: Driver<PurchaseStatus?>
    }
    
    //MARK:- Transform
    func transform(input: Input) -> Output {
        
        let price = BehaviorRelay<String>.init(value: "$2.99 per week, auto-renewable")
        let purchaseStatus = BehaviorRelay<PurchaseStatus?>.init(value: nil)

        getProductionInfo()
            .subscribeOn(MainScheduler.instance)
            .bind(to: price)
            .disposed(by: bag)
        
        let countdown = FlashSaleManager.shared.counter
            .map {"Limited time: \(Double($0).toMSWithoutHour()) minutes"}
        
        input.dismiss
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                guard let coordinator = self.coordinator as? PremiumACoordinator else { return }
                coordinator.pop()
            })
            .disposed(by: bag)
        
        Observable.merge(input.privacyTrigger,input.termOfUseTrigger)
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                guard let coordinator = self.coordinator as? PremiumACoordinator else { return }
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
                    guard let coordinator = self.coordinator as? PremiumACoordinator else { return }
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

                    guard let coordinator = self.coordinator as? PremiumACoordinator else { return }
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
            countDown: countdown.asDriver(onErrorJustReturn: "Limited time: 5:00 minutes"),
            price: price.asDriver(onErrorJustReturn: "$2.99 per week, auto-renewable"),
            purchaseStatus: purchaseStatus.asDriver(onErrorJustReturn: nil)

        )
    }
    
    //MARK:- Logic&Functions
//    func startTimer() {
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (t) in
//            self.counter.accept(self.counter.value - 1)
//            Defaults[\.flashSaleCounter] = self.counter.value - 1
//            if self.counter.value == 0 {
//                self.stopTimer()
//            }
//        })
//    }
//
//    func stopTimer() {
//        timer?.invalidate()
//        timer = nil
//        self.counter.accept(0)
//    }
    
    
    func getProductionInfo() -> Observable<String> {
        return Observable.create { (observable) -> Disposable in
            log.debug("Get purchase info")
            Purchaser.getInfo(ProductIds: [Keys.monthy.appId]) { (skProducts) in
                for i in skProducts {
                    if i.productIdentifier == Keys.monthy.appId {
                        observable.onNext("$2.99 for first week\n then \(i.localizedPrice ?? "$x.xx") per week, auto-renewable")
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
            let productToPurchase = Keys.monthy.appId
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

