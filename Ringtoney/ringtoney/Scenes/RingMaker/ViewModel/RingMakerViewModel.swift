//
//  RingMakerViewModel.swift
//  ringtoney
//
//  Created by dong ka on 11/12/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import AVFoundation


class RingMakerViewModel: ViewModel , ViewModelType {
    
    //MARK:- Property
    var makerModel: MakerModel!
    
    private var player: AVPlayer?
    private var observer: Any?
    
    var animateDuration = BehaviorRelay<Double>.init(value: 0)
    
    let isPlay = BehaviorRelay<Bool>.init(value: false)

    //MARK:- Init
    override init() {
        super.init()
    }
    
    init(makerModel: MakerModel) {
        super.init()
        self.makerModel = makerModel
    }
    
    //MARK:- Input
    struct Input {
        let dismiss: Observable<Void>
        let set10sec: Observable<Void>
        let set20sec: Observable<Void>
        let set30sec: Observable<Void>
        let set40sec: Observable<Void>
        let fadeInTrigger: Observable<Void>
        let fadeOutTrigger: Observable<Void>
        let startTrimTime: Observable<Double>
        let trimDuration: Observable<Double>
        let soundEffectTrigger: Observable<Float>
        let playTrigger: Observable<Void>
        let renameTrigger: Observable<String?>
        let saveTrigger: Observable<Void>
        let tutorialTrigger: Observable<Void>
        let premiumTrigger: Observable<Void>

    }
    
    //MARK:- Output
    struct Output {
        let limitDuration: Driver<Double>
        let fadeIn: Driver<Bool>
        let fadeOut: Driver<Bool>
        let isPlay: Driver<Bool>
        let animateDuration: Observable<Double>
        let makerStatus: Driver<MakerStatus?>
        let showLoading: Driver<Bool>
    }
    
    //MARK:- Transform
    func transform(input: Input) -> Output {
        
        let showLoading = BehaviorRelay<Bool>(value: false)
        let limitDuration = BehaviorRelay<Double>.init(value: 10)
        let fadeIn = BehaviorRelay<Bool>.init(value: false)
        let fadeOut = BehaviorRelay<Bool>.init(value: false)
        let makerStatus = BehaviorRelay<MakerStatus?>.init(value: nil)
        
        input.renameTrigger
            .compactMap{$0}
            .subscribe(onNext:{[weak self] txt in
                guard let self = self else { return }
                self.makerModel.audioName = txt
            })
            .disposed(by: bag)
        
        input.set10sec
            .map {10}
            .bind(to: limitDuration)
            .disposed(by: bag)
        
        input.set20sec
            .map {20}
            .subscribe(onNext: {[weak self] i in
                guard let self = self else { return }
                if IS_PURCHASED() {
                    limitDuration.accept(Double(i))
                } else {
                    guard let coordinator = self.coordinator as? RingMakerCoordinator else { return }
                    coordinator.openPremiumB()
                }
            })
            .disposed(by: bag)
        
        input.set30sec
            .map {30}
            .subscribe(onNext: {[weak self] i in
                guard let self = self else { return }
                if IS_PURCHASED() {
                    limitDuration.accept(Double(i))
                } else {
                    guard let coordinator = self.coordinator as? RingMakerCoordinator else { return }
                    coordinator.openPremiumB()
                }
            })
            .disposed(by: bag)
        
        input.set40sec
            .map {40}
            .subscribe(onNext: {[weak self] i in
                guard let self = self else { return }
                if IS_PURCHASED() {
                    limitDuration.accept(Double(i))
                } else {
                    guard let coordinator = self.coordinator as? RingMakerCoordinator else { return }
                    coordinator.openPremiumB()
                }
            })
            .disposed(by: bag)
        
        let fadein = input.fadeInTrigger.map {!fadeIn.value}.share()
        
        fadein
            .bind(to: fadeIn)
            .disposed(by: bag)
        
        fadein
            .subscribe(onNext:{[weak self] value in
                guard let self = self else { return }
                self.makerModel.enableFadein = value
            })
            .disposed(by: bag)
        
        let fadeout = input.fadeOutTrigger.map {!fadeOut.value}.share()
            
        fadeout
            .bind(to: fadeOut)
            .disposed(by: bag)
        
        fadeout
            .subscribe(onNext:{[weak self] value in
                guard let self = self else { return }
                self.makerModel.enableFadeout = value
            })
            .disposed(by: bag)
        
        input.startTrimTime
            .subscribe(onNext:{[weak self] value in
                guard let self = self else { return }
                self.makerModel.startTrimTime = value
            })
            .disposed(by: bag)
        
        input.trimDuration
            .subscribe(onNext:{[weak self] value in
                guard let self = self else { return }
                self.makerModel.trimDuration = value
            })
            .disposed(by: bag)
        
        input.playTrigger
            .subscribe(onNext:{[weak self ] _ in
                guard let self = self else { return }
                if self.isPlay.value {
                    self.stopAudio()
                    self.isPlay.accept(false)
                } else {
                    self.playAudio(complete: {
                        self.isPlay.accept(true)
                    })
                }
            })
            .disposed(by: bag)
        
        input.soundEffectTrigger
            .subscribe(onNext:{[weak self] value in
                guard let self = self else { return }
                self.makerModel.speed = Double(value)
            })
            .disposed(by: bag)
        
        //Save
        input.saveTrigger
            .do(onNext:{[weak self] _ in
                showLoading.accept(true)
            })
            .subscribe(onNext:{[weak self] _ in
                //Code export
                guard let self = self else { return }
                
                self.makerModel.exportAudio { (status) in
                    log.debug("Status: = \(status)")
                    showLoading.accept(false)
                    makerStatus.accept(.success)
                }
            })
            .disposed(by: bag)
        
        //Show tutorial
        input.tutorialTrigger
            .subscribe(onNext:{[weak self] _ in
              //Code show tutorial
                guard let self = self else { return }
                guard let coordinator = self.coordinator as? RingMakerCoordinator else { return }
                coordinator.openTutorial()
            })
            .disposed(by: bag)
        
        
        input.dismiss
            .subscribe(onNext:{ _ in
                self.stopAudio()
                guard let coordinator = self.coordinator as? RingMakerCoordinator else { return }
                coordinator.pop()
                
            })
            .disposed(by: bag)
        
        input.premiumTrigger
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                guard let coordinator = self.coordinator as? RingMakerCoordinator else { return }
                coordinator.openPremiumB()
            })
            .disposed(by: bag)
        
        return Output.init(
            limitDuration: limitDuration.asDriver(onErrorJustReturn: 10),
            fadeIn: fadeIn.asDriver(onErrorJustReturn: false),
            fadeOut: fadeOut.asDriver(onErrorJustReturn: false),
            isPlay: isPlay.asDriver(onErrorJustReturn: false),
            animateDuration: self.animateDuration.asObservable(),
            makerStatus: makerStatus.asDriver(onErrorJustReturn: nil),
            showLoading: showLoading.asDriver(onErrorJustReturn: false)
        )
    }
    
    //MARK:- Logic&Functions
    
    
    func playAudio(complete: @escaping () -> Void) {
        makerModel.trimAudio {
            
            let url = self.makerModel.trimURL
            //Play audio
            do {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            }
            catch {
                print("Cannot play this song!")
            }
            guard let audioURL = url
                else { print("cannot play audio!") ; return }
            let playerItem = AVPlayerItem.init(url: audioURL)
            self.player = AVPlayer.init(playerItem: playerItem)
            self.makerModel.playerItem = playerItem
            self.animateDuration.accept(self.makerModel.audioDuration)
            
            log.debug("ABC: \(self.makerModel.audioDuration)")
            
            self.player?.play()
            complete()
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.playerDidFinishPlaying),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: self.player?.currentItem)
        }
        
    }
    
    func stopAudio() {
        player?.pause()
        player = nil
    }
    
    @objc private func playerDidFinishPlaying(notification: NSNotification){
        print("Audio finished")
        isPlay.accept(false)
        // guard let currentRingtone = self.currentRingtone else { return }
        // delegate?.audioPlayerDidFinishPlayAudio(currentRingtone, lastRingtone: lastRingtone)
    }
    
    
}

