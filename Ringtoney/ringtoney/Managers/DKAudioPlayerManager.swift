//
//  DKAudioPlayerManager.swift
//  ringtoney
//
//  Created by dong ka on 19/11/2020.
//

import Foundation
import AVFoundation



class DNAudioPlayerManager: NSObject {
        
    private var player: AVPlayer?
    private var observer: Any?
    
    private var lastRingtone: Ringtone?
    private var currentRingtone: Ringtone?
    
    static let shared = DNAudioPlayerManager()
    
    let didFinshPlayAudio = PublishSubject<Void>.init()
    
    func playAudio( ringtone: Ringtone ) {
        
        lastRingtone = currentRingtone
        currentRingtone = ringtone
        
        do {
            try AVAudioSession.sharedInstance()
                .overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        }
        catch {
            print("Cannot play this song!")
        }
        
        guard let currentRingtone = self.currentRingtone,
              let audioURL = currentRingtone.audioURL
        else { print("cannot play audio!") ; return }
        
        let playerItem = AVPlayerItem.init(url: audioURL)
        player = AVPlayer.init(playerItem: playerItem)
        let duration =  playerItem.asset.duration
        let seconds = CMTimeGetSeconds(duration)
        currentRingtone.totalDuration = Double(seconds)
        log.debug("Audio duration: \(Double(seconds))")
        player?.play()
        //delegate?.audioPlayerDidPlay(currentRingtone, lastRingtone: lastRingtone)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
        
        self.observer = player?.addPeriodicTimeObserver(forInterval: CMTime.init(seconds: 0.05, preferredTimescale: 1000), queue: DispatchQueue.main, using: {[weak self] (time) in
            guard let `self` = self, let player = self.player else { return }
            if player.currentItem?.status == .readyToPlay {
                let currentTime = CMTimeGetSeconds(self.player!.currentTime())
                let sec: Double = Double(currentTime) <= 0 ? 0 : Double(currentTime)
                currentRingtone.currentDuration = sec
            }
            
        })
        
    }
    
    func pauseAudio() {
        player?.pause()
        player?.removeTimeObserver(self.observer as Any)
        player = nil
        didFinshPlayAudio.onNext(())
    }
    
    @objc private func playerDidFinishPlaying(notification: NSNotification){
        print("Audio finished")
        guard let currentRingtone = self.currentRingtone else { return }
        didFinshPlayAudio.onNext(())
    }
    
}
