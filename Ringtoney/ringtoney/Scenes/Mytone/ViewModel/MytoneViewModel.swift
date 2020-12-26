//
//  MytoneViewModel.swift
//  ringtoney
//
//  Created by dong ka on 11/2/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation


class MytoneViewModel: ViewModel , ViewModelType, DatabaseUpdating {
    
    //MARK:- Property
    private let didUpdateContent = PublishSubject<Void>.init()
    
    //MARK:- Init
    override init() {
        super.init()
        Broadcaster.register(DatabaseUpdating.self, observer: self)
    }
    
    //MARK:- Input
    struct Input {
        let recordSelected: Observable<Void>
        let ringtoneTabTrigger: Observable<Void>
        let trackTabTrigger: Observable<Void>
        let playpauseTrigger: Observable<Int>
        let moreTrigger: Observable<Int>
        
        ///More option
        let editTrigger: Observable<Ringtone>
        let renameTrigger: Observable<Ringtone>
        let deleteTringer: Observable<Ringtone>
        let installTrigger: Observable<Ringtone>
        
        ///Premium Trigger
        let premiumTrigger: Observable<Void>

    }
    
    //MARK:- Output
    struct Output {
        let items: Driver<[MyToneCellViewModel]>
        let isSelectedTrackTab: Driver<Bool>
        let showMoreOption: Observable<Ringtone>
    }
    
    //MARK:- Transform
    func transform(input: Input) -> Output {
        
        let elements = BehaviorRelay<[MyToneCellViewModel]>.init(value: [])
        let isSelectedTrackTab = BehaviorRelay<Bool>.init(value: true)
        
        var currentIndex = -1
        let moreOption = PublishSubject<Ringtone>.init()
        
        didUpdateContent
            .flatMap{self.fetchData(isSelectedTrackTab.value)}
            .map{$0.map{MyToneCellViewModel.init(ringtone: $0)}}
            .bind(to: elements)
            .disposed(by: bag)
        
        isSelectedTrackTab
            .flatMap{self.fetchData($0)}
            .map{$0.map{MyToneCellViewModel.init(ringtone: $0)}}
            .bind(to: elements)
            .disposed(by: bag)

        isSelectedTrackTab
            .subscribe(onNext:{[weak self] _ in
                DNAudioPlayerManager.shared.pauseAudio()
            })
            .disposed(by: bag)
        
        input.ringtoneTabTrigger
            .map { false }
            .bind(to: isSelectedTrackTab)
            .disposed(by: bag)
        
        input.trackTabTrigger
            .map { true }
            .bind(to: isSelectedTrackTab)
            .disposed(by: bag)
        
        input.recordSelected
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                guard let coordinator = self.coordinator as? MytoneCoordinator else { return }
                coordinator.openRecord()
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
            .map {elements.value[$0].ringtone}
            .bind(to: moreOption)
            .disposed(by: bag)
        
        input.editTrigger
            .subscribe(onNext:{[weak self] ringtone in
                guard let self = self else { return }
                guard let coordinator = self.coordinator as? MytoneCoordinator else { return }
                guard let audioURL = ringtone.audioURL else { return }
                coordinator.openMaker(audioURL: audioURL)
            })
            .disposed(by: bag)
        
        input.renameTrigger
            .subscribe(onNext:{[weak self] ringtone in
                guard let self = self else { return }
                DatabaseManager.shared.editRingtoneName(NewName: ringtone.name, id: ringtone.databaseID!)
            })
            .disposed(by: bag)
        
        input.deleteTringer
            .subscribe(onNext:{[weak self] ringtone in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    
                    if elements.value[currentIndex].ringtone.audioPath == ringtone.audioPath {
                        DNAudioPlayerManager.shared.pauseAudio()
                    }
                    
                    DatabaseManager.shared.removeRingtone(id: ringtone.databaseID!)
                }
            })
            .disposed(by: bag)
        
        input.installTrigger
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext:{[weak self] ringtone in
                guard let self = self else { return }
                //Install ringtone
                guard let coordinator = self.coordinator as? MytoneCoordinator else { return }
                coordinator.openTutorial()
                DNDownloadManager.exportRingtone(ringtone)
            })
            .disposed(by: bag)
        
        input.premiumTrigger
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                guard let coordinator = self.coordinator as? MytoneCoordinator else { return }
                coordinator.openPremiumB()
            })
            .disposed(by: bag)
        
        return Output.init(
            items: elements.asDriver(onErrorJustReturn: []),
            isSelectedTrackTab: isSelectedTrackTab.asDriver(onErrorJustReturn: true),
            showMoreOption: moreOption.asObserver()
        )
    }
    
    //MARK:- Logic&Functions
    func fetchData(_ isPremium: Bool) -> Observable<[Ringtone]> {
        return Observable.create { (observable) -> Disposable in
            
            var ringtones: [Ringtone] = []
            
            if isPremium {
                ringtones += DatabaseManager.shared.listPremiumTones()
                observable.onNext(ringtones)
                observable.onCompleted()
            } else {
                //Load local audio
                ringtones += DatabaseManager.shared.listRingMakerTones()
                observable.onNext(ringtones)
                observable.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    //MARK:- Database updateing
    func createRingtone() {
        didUpdateContent.onNext(())
    }
    
    func updateRingtone(id: String, newName: String) {
        didUpdateContent.onNext(())
    }
    
    func deleteRingtone() {
        didUpdateContent.onNext(())
    }

    
}

