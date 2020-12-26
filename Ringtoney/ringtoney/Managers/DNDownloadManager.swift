//
//  DNDownloadManager.swift
//  ringtoney
//
//  Created by dong ka on 28/11/2020.
//

import Foundation
import AVFoundation

class DNDownloadManager: NSObject {
    
    class func store( ringtone: Ringtone) {
        
        //Read from local path
        //"origin_url": "1599297877_Whistling_SMS.m4r",
        let localPath = Configs.FolderPath.ringtone + "/" + ringtone.origin_url
        
        //Get duration
        guard let audioURL = FCFileManager.urlForItem(atPath: localPath) else { return }
        let playerItem = AVPlayerItem.init(url: audioURL)
        let seconds = CMTimeGetSeconds(playerItem.asset.duration)
        let duration = Double(seconds)

        log.debug("Saved duration: \(duration)")
        log.debug("Path: \(localPath)")
        
        log.debug(FCFileManager.urlForItem(atPath: localPath))
        
        //Store
        DatabaseManager.shared.createPremiumRingtone(name: ringtone.name,
                                                     duration: duration,
                                                     path: localPath)
        
    }
    
    class func exportRingtone(_ ringtone: Ringtone) {
        guard let lastPath = ringtone.audioURL?.lastPathComponent else { return }
        let fromPath = Configs.FolderPath.ringtone + "/" + lastPath
        let toPath = ringtone.name + ".m4r"
        FCFileManager.removeItem(atPath: toPath)
        FCFileManager.copyItem(atPath: fromPath, toPath: toPath)
    }
    
}
