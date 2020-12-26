//
//  RecordViewModel.swift
//  ringtoney
//
//  Created by dong ka on 11/10/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import AVFoundation

class RecordViewModel: ViewModel , ViewModelType {
    
    //MARK:- Property
    
    
    //MARK:- Init
    override init() {
        super.init()
    }
    
    //MARK:- Input
    struct Input {
        let dismiss: Observable<Void>
        let makerTrigger: Observable<Void>
        let saveTrigger: Observable<Void>
        let playPauseTrigger: Observable<Void>
        let finishPlayAudio: Observable<Void>
    }
    
    //MARK:- Output
    struct Output {
        let isPlay: Driver<Bool>
    }
    
    //MARK:- Transform
    func transform(input: Input) -> Output {
        
        let isPlayingSubject = PublishSubject<Bool>()
        var _isPlaying = false
        
        input.playPauseTrigger
            .map { !_isPlaying }
            .do(onNext:{ value in
                _isPlaying = value
            })
            .bind(to: isPlayingSubject)
            .disposed(by: bag)
        
        input.finishPlayAudio
            .map { false }
            .do(onNext:{ _ in
                _isPlaying = false
            })
            .bind(to: isPlayingSubject)
            .disposed(by: bag)
        
        input.makerTrigger
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                guard let coordinator = self.coordinator as? RecordCoordinator else { return }
                guard let recordURL = AudioRecorderManager.shared.currentRecordPath else { return }
                coordinator.openRingMaker(audioURL: recordURL)
            })
            .disposed(by: bag)
        
        input.saveTrigger
            .subscribe(onNext:{[weak self] _ in
                //Code to save
                guard let self = self else { return }
                self.saveRecord()
                
            })
            .disposed(by: bag)
        
        input.dismiss
            .subscribe(onNext:{ _ in
                guard let coordinator = self.coordinator as? RecordCoordinator else { return }
                coordinator.pop()
            })
            .disposed(by: bag)
        
        return Output.init(isPlay: isPlayingSubject.asDriver(onErrorJustReturn: false))
    }
    
    //MARK:- Logic&Functions
    private func saveRecord() {
        
//        //Auto create folder
        FCFileManager.createDirectories(forPath: Configs.FolderPath.ringtone)
//
        guard let recordURL = AudioRecorderManager.shared.currentRecordPath else { return }
//
//        //Tmp path
        let fromPath = recordURL.lastPathComponent
//
//        //New path
        let _uuid = UUID().uuidString.lowercased()
        let toPath = Configs.FolderPath.ringtone + "/" + _uuid + recordURL.lastPathComponent
//
        log.debug("From: \(fromPath)")
        log.debug("To: \(toPath)")
//
//        //Save item in database

        let recordDuration = duration(for: recordURL.absoluteString)
        
        log.debug("Record duration: \(recordDuration)")
        
        DispatchQueue.main.async {

            let ring_name: String = "My record"
            DatabaseManager.shared.create(name: ring_name,
                                          duration: recordDuration,
                                          path: toPath)
        }
//
//        //Move path
        let status = FCFileManager.copyItem(atPath: fromPath, toPath: toPath)

    }
    
    func duration(for resource: String) -> Double {
        let asset = AVURLAsset(url: URL(fileURLWithPath: resource))
        return Double(CMTimeGetSeconds(asset.duration))
    }
    
}

