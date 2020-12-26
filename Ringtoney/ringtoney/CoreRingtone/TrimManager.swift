//
//  TrimManager.swift
//  ringtoney
//
//  Created by dong ka on 16/11/2020.
//

import Foundation
import AVFoundation
import CoreAudio
import FCFileManager

final class TrimManager : NSObject {
    
    class func trim( url: URL,
                     start: Double,
                     duration: Double,
                     speed: Float,
                     fadeIn: Bool,
                     fadeOut: Bool,
                     completionHandler : @escaping (URL) -> Void,
                     failure: @escaping () -> Void ) {
        
        FCFileManager.createDirectories(forPath: ".tmp/")
        FCFileManager.removeItem(atPath: ".tmp/tmp.m4r")
        
        if !FCFileManager.existsItem(atPath: ".tmp/tmp.m4r") {
            
            //Do that here
            log.debug("Input: \(url.lastPathComponent)")
            log.debug("Input: start \(start) - duration: \(duration) ")
            log.debug("Input: speed \(speed)")
            log.debug("Input: fadeIn \(fadeIn) - fadeOut: \(fadeOut) ")
            
            let asset = AVURLAsset(url: url)
            let composition = AVMutableComposition()
            guard let audioAssetSourceTrack = asset.tracks(withMediaType: AVMediaType.audio).first else { return}
            let audioCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
            
            do {
                try audioCompositionTrack?.insertTimeRange(
                    CMTimeRangeMake(start: CMTimeMakeWithSeconds(start, preferredTimescale: 1000000), duration: CMTimeMakeWithSeconds(duration, preferredTimescale: 1000000)),
                    of: audioAssetSourceTrack,
                    at: CMTime.zero)
                
//                TrimManager.rateSpeed(audioAsset: asset, audioAssetSourceTrack: audioAssetSourceTrack, audioCompositionTrack: audioCompositionTrack!, speed: Double(speed))
                
                
            } catch {
                log.debug("Trim time falure")
            }
            
            let newAsset = composition
            
            let removeStatus = FCFileManager.removeItem(atPath: ".tmp/tmp.m4r")
            log.debug("Remove item tmp.m4r status = \(removeStatus)")
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
            let filePath = documentsDirectory.appendingPathComponent(".tmp/tmp.m4r")
            
            if let exportSession = AVAssetExportSession.init(asset: newAsset, presetName: AVAssetExportPresetAppleM4A) {
                exportSession.canPerformMultiplePassesOverSourceMediaData = true
                exportSession.outputURL = filePath
                exportSession.outputFileType = AVFileType.m4a
                
                exportSession.audioMix = fadeInfadeOut(turnOnFadeIn: fadeIn,
                                                       turnOnFadeOut: fadeOut,
                                                       trimTime: duration,
                                                       audioAssetSourceTrack: audioAssetSourceTrack,
                                                       audioAsset: asset)

                
                exportSession.exportAsynchronously {
                    DispatchQueue.main.async {
                        log.debug("Output: \(filePath)")
                        self.fakeAnimalSound(filePath, Double(speed), { output in
                            completionHandler(output)
                        })
                    }
                }
            }
            
        } else {
            //We don't do that here
            failure()
        }
        
    }
    
    
    class func fakeAnimalSound(_ url: URL,
                               _ speed: Double = 1.0,
                               _ completion: @escaping (URL) -> Void) {
        
        let audioAsset = AVURLAsset(url: url)
        guard let audioAssetSourceTrack = audioAsset.tracks(withMediaType: AVMediaType.audio).first else { return }
        
        let composition = AVMutableComposition()
        let audioCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        let durationInSeconds = CMTimeGetSeconds(audioAsset.duration)
        let audioDuration = Double(durationInSeconds)
        
        do {
            try audioCompositionTrack?.insertTimeRange(
                CMTimeRangeMake(start: CMTimeMakeWithSeconds(0.0, preferredTimescale: 1000000), duration: CMTimeMakeWithSeconds(audioDuration, preferredTimescale: 1000000)),
                of: audioAssetSourceTrack,
                at: CMTime.zero)
            
        }
            
        catch { log.debug(error) }
        
        //Create audio from Asset
        //Remove
        FCFileManager.removeItem(atPath: ".tmp/tmp.m4r")
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        FCFileManager.createDirectories(forPath: ".tmp/")
        let filePath = documentsDirectory.appendingPathComponent(".tmp/tmp.m4r")
        
        if let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A){
            exportSession.canPerformMultiplePassesOverSourceMediaData = true
            exportSession.outputURL = filePath as URL
            exportSession.outputFileType = AVFileType.m4a
            
            exportSession.audioTimePitchAlgorithm = .varispeed
            
            let audioDuration = audioAsset.duration
            let finalTimeScale = Float(audioDuration.value) / Float(speed)
            audioCompositionTrack!.scaleTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: audioDuration), toDuration: CMTimeMake(value: Int64(finalTimeScale), timescale: audioDuration.timescale))
            exportSession.exportAsynchronously {
                log.debug("File Path : \(filePath)")
                completion(filePath as URL)
            }
        }else{
            //Fail
        }
    }
    
    class func rateSpeed(audioAsset:AVURLAsset,
                         audioAssetSourceTrack:AVAssetTrack,
                         audioCompositionTrack:AVMutableCompositionTrack,
                         speed:Double) {
        
        let audioDuration = audioAsset.duration
        let finalTimeScale = Float(audioDuration.value) / Float(speed)
        audioCompositionTrack.scaleTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: audioDuration), toDuration: CMTimeMake(value: Int64(finalTimeScale), timescale: audioDuration.timescale))
    }
    
    class func fadeInfadeOut(turnOnFadeIn:Bool,
                             turnOnFadeOut:Bool,
                             trimTime:Double,
                             audioAssetSourceTrack:AVAssetTrack,
                             audioAsset:AVURLAsset) -> AVMutableAudioMix {
        
        let exportAudioMix = AVMutableAudioMix()
        let exportAudioMixInputParameters = AVMutableAudioMixInputParameters.init(track: audioAssetSourceTrack)
        
        if trimTime > 9.0 {
            let fadeInStart = CMTime.init(seconds: 0.0, preferredTimescale: 1)
            let fadeInEnd = CMTime.init(seconds: 2.0, preferredTimescale: 1)
          let fadeOutStart = CMTime.init(seconds: trimTime, preferredTimescale: 1) - (CMTime.init(seconds: 4.0, preferredTimescale: 1))
          let fadeOutEnd = CMTime.init(seconds: trimTime, preferredTimescale: 1)
            
            let fadeIn = CMTimeRangeFromTimeToTime(start: fadeInStart,end: fadeInEnd)
            let fadeOut = CMTimeRangeFromTimeToTime(start: fadeOutStart,end: fadeOutEnd)
            //fadeIn
            if turnOnFadeIn == true {
                exportAudioMixInputParameters.setVolumeRamp(fromStartVolume: 0, toEndVolume: 1, timeRange: fadeIn)
                log.debug("Turn on: Fade In")
            }
            //fadeOut
            if turnOnFadeOut == true {
                exportAudioMixInputParameters.setVolumeRamp(fromStartVolume: 1, toEndVolume: 0, timeRange: fadeOut)
                log.debug("Turn on: Fade Out")
            }
    
            exportAudioMix.inputParameters = [exportAudioMixInputParameters]
        }
        
        return exportAudioMix
    }
    
    
}
