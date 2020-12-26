//
//  CategoryDetailViewModel.swift
//  ringtoney
//
//  Created by dong ka on 11/8/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation


class CategoryDetailViewModel: ViewModel , ViewModelType {
    
    //MARK:- Property
    var category: Category?
    var page: Int = 1
    
    let finishLoadmore = PublishSubject<Void>.init()
    
    
    //MARK:- Init
    override init() {
        super.init()
    }
    
    init(category: Category?) {
        super.init()
        self.category = category
    }
    
    //MARK:- Input
    struct Input {
        let dismiss: Observable<Void>
        let playpauseTrigger: Observable<Int>
        let moreTrigger: Observable<Int>
        let loadMore: Observable<Void>
    }
    
    //MARK:- Output
    struct Output {
        let items: Driver<[CategoryDetailCellViewModel]>
        let title: Driver<String>
        let finishInfinityScroll: Observable<Void>
    }
    
    //MARK:- Transform
    func transform(input: Input) -> Output {
        
        let elements = BehaviorRelay<[CategoryDetailCellViewModel]>.init(value: [])
        var currentIndex = -1
        let title = PublishSubject<String>.init()
        
        fetchData()
            .do {[weak self] _ in
                guard let self = self else { return }
                title.onNext(self.category?.title ?? "")
            }
            .map{$0.map{CategoryDetailCellViewModel.init(ringtone: $0)}}
            .subscribe(onNext:{[weak self] value in
                elements.accept(elements.value + value)
            })
            .disposed(by: bag)
        
        input.dismiss
            .subscribe(onNext:{_ in
                DNAudioPlayerManager.shared.pauseAudio()
                guard let coordinator = self.coordinator as? CategoryDetailCoordinator else { return }
                coordinator.pop()
                
            })
            .disposed(by: bag)
        
        input.playpauseTrigger
            .subscribe(onNext:{[weak self] idx in
                guard let self = self else { return }
                
                
                log.debug("IndexPath: \(idx)")
                
                //Reload all cell
                for ( index, element) in elements.value.enumerated() {
                    if index != idx { element.isPlay.accept(false) }
                }
                
                //TH1: Play pause in current cell
                if currentIndex == idx {
                    elements.value[idx].isPlay.accept(!elements.value[idx].isPlay.value)
                }
                else {
                    if IAPManager.checkListentedCounter() {
                        DNAudioPlayerManager.shared.pauseAudio()
                        elements.value[idx].isPlay.accept(true)
                    } else {
                        guard let coordinator = self.coordinator as? CategoryDetailCoordinator else { return }
                        coordinator.openPremiumB()
                    }
                }
                
                currentIndex = idx
                
                if elements.value[idx].isPlay.value {
                    DNAudioPlayerManager.shared.playAudio(ringtone: elements.value[idx].ringtone)
                } else {
                    DNAudioPlayerManager.shared.pauseAudio()
                }
                
            })
            .disposed(by: bag)
        
        DNAudioPlayerManager.shared.didFinshPlayAudio
            .subscribe(onNext:{[weak self] _ in
                for ( index, element) in elements.value.enumerated() {
                    element.isPlay.accept(false)
                }
            })
            .disposed(by: bag)
        
        input.moreTrigger
            .map {$0}
            .subscribe(onNext:{[weak self] index in
                guard let self = self else { return }
                //Code to download ringtone
                //call provider download
                if IAPManager.checkDownloadCounter() {
                    elements.value[index].isDownloaded.accept(true)
                    self.downloadRingtone(ringtone: elements.value[index].ringtone)
                } else {
                    guard let coordinator = self.coordinator as? CategoryDetailCoordinator else { return }
                    coordinator.openPremiumB()
                }
                
            })
            .disposed(by: bag)
        
        input.loadMore
            .do(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.page += 1
            })
            .flatMap { self.fetchData() }
            .map{$0.map{CategoryDetailCellViewModel.init(ringtone: $0)}}
            .subscribe(onNext:{[weak self] value in
                elements.accept(elements.value + value)
            })
            .disposed(by: bag)
        
        return Output.init(
            items: elements.asDriver(onErrorJustReturn: []),
            title: title.asDriver(onErrorJustReturn: ""),
            finishInfinityScroll: self.finishLoadmore.asObserver()
        )
    }
    
    //MARK:- Logic&Functions
    func fetchData() -> Observable<[Ringtone]> {
        return Observable.create { (observable) -> Disposable in
            guard let cate = self.category else { return Disposables.create() }
            self.provider?.detailCategory(cateId: cate.id, page: self.page)
                .subscribe(onSuccess: { (ringtones) in
                    observable.onNext(ringtones)
                    observable.onCompleted()
                    self.finishLoadmore.onNext(())
                }, onError: { (error) in
                    log.debug(error)
                    observable.onNext([])
                    observable.onCompleted()
                    self.finishLoadmore.onNext(())
                }).disposed(by: self.bag)
            return Disposables.create()
        }
    }
    
    func downloadRingtone( ringtone: Ringtone) {
        //            "original_path": "https://wallpaper-api.s3-ap-southeast-1.amazonaws.com\\test/ringtone/ringtone\\1599297877_Whistling_SMS.m4r"
        
        guard let urlToDownload = URL.init(string: ringtone.original_path) else { return }
        self.provider?.downloadFile(url: urlToDownload , fileName: ringtone.origin_url)
            .subscribe(onSuccess: { (json) in
                //Code
                //Save ringtone to Realm
                DNDownloadManager.store(ringtone: ringtone)
                
            }, onError: { (error) in
                log.debug(error)
            }).disposed(by: self.bag)
    }
    
    
    
    
}

