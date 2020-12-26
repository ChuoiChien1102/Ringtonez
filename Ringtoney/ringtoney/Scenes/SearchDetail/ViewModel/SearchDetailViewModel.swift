//
//  SearchDetailViewModel.swift
//  ringtoney
//
//  Created by dong ka on 11/10/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation


class SearchDetailViewModel: ViewModel , ViewModelType {
    
    //MARK:- Property
    var searchString = ""
    
    var page: Int = 1
    let finishLoadmore = PublishSubject<Void>.init()
    let title = BehaviorRelay<String>.init(value: "")

    //MARK:- Init
    override init() {
        super.init()
    }
    
    init(searchString: String) {
        super.init()
        self.searchString = searchString
        title.accept("Results of: \(searchString)")
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
        
        fetchData()
            .map{$0.map{CategoryDetailCellViewModel.init(ringtone: $0)}}
            .bind(to: elements)
            .disposed(by: bag)

        
        input.dismiss
            .subscribe(onNext:{_ in
                guard let coordinator = self.coordinator as? SearchDetailCoordinator else { return }
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
                    elements.value[idx].isPlay.accept(true)
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
                //Code to download ringtone
                //call provider download
                elements.value[index].isDownloaded.accept(true)
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
            title: self.title.asDriver(onErrorJustReturn: ""),
            finishInfinityScroll: self.finishLoadmore.asObserver()
        )
    }
    
    //MARK:- Logic&Functions
    func fetchData() -> Observable<[Ringtone]> {
        return Observable.create { (observable) -> Disposable in
            self.provider?.search(key: self.searchString, page: self.page)
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

    
    
    
    
}

