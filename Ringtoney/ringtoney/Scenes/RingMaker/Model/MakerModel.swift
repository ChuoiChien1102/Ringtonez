//
//  MakerModel.swift
//  ringtoney
//
//  Created by dong ka on 16/11/2020.
//

import Foundation
import AVFoundation

class MakerModel : NSObject {
    
    var audioName: String = ""
    var audioPath: String = ""
    
    var enableFadein: Bool = false
    var enableFadeout: Bool = false
    
    var speed: Double = 1.0
    
    var startTrimTime: Double = 0
    var trimDuration: Double = 20
    
    var playerItem: AVPlayerItem!
    var trimURL: URL? //trim path
    
    var audioDuration: Double {
        get {
            playerItem = AVPlayerItem.init(url: trimURL!)
            let value =  Double(playerItem.asset.duration.value)
            let timeScale = Double(playerItem.asset.duration.timescale)
            let _duration =  value / timeScale
            return _duration
        }
    }
    
    
    var audioURL: URL? {
        get {
            return audioPath.isEmpty ? getAudioTest() : URL.init(fileURLWithPath: audioPath)
        }
    }

    private func getAudioTest() -> URL? {
        return Bundle.main.url(forResource: "audio2", withExtension: "mp3")
    }
    
    func trimAudio(completed: @escaping () -> Void ) {
        guard let url = self.audioURL else {
            log.debug("Cannot get ringtone URL")
            return }
        
        TrimManager.trim(url: url,
                         start: self.startTrimTime,
                         duration: Double(self.trimDuration),
                         speed: Float(self.speed),
                         fadeIn: self.enableFadein,
                         fadeOut: self.enableFadeout,
                         completionHandler: { (newURL) in
                            self.trimURL = newURL
                            completed()
        }) {
            //Error
        }
        
    }
    
    //Lưu nhạc
    func exportAudio(completed: @escaping (Bool) -> Void) {
        
        
        func export() {
            
            //Auto create folder
            FCFileManager.createDirectories(forPath: Configs.FolderPath.ringtone)
            
            //Tmp path
            let fromPath = ".tmp/tmp.m4r"
            
            //New path
            let _uuid = UUID().uuidString.lowercased()
            let toPath = Configs.FolderPath.ringtone + "/" + (self.audioName == "" ?  _uuid : self.audioName) + ".m4r"
            
            log.debug("From: \(fromPath)")
            log.debug("To: \(toPath)")
            
            //Save item in database
            
            DispatchQueue.main.async {

                let ring_name: String = self.audioName == "" ? "my ringtone" : self.audioName
                DatabaseManager.shared.create(name: ring_name,
                                              duration: self.audioDuration,
                                              path: toPath)
                self.trimURL = nil
            }
            
            //Move path
            let status = FCFileManager.copyItem(atPath: fromPath, toPath: toPath)
            completed(status)
            
        }
        
        //Export Audio
        
        if self.trimURL == nil {
            self.trimAudio {
                export()
            }
        } else {
            export()
        }
        
        
    }
    
    
}
