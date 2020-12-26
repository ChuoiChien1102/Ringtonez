//
//  DNDownloadManager.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 12/4/20.
//

import Foundation
import AVFoundation
import FCFileManager

class DNDownloadManager: NSObject {
    
    class func store( ringtone: RingToneModel) {
        
        //Read from local path
        //"origin_url": "1599297877_Whistling_SMS.m4r",
        let localPath = FolderPath.ringtone + "/" + ringtone.origin_url
        
        //Get duration
        guard let audioURL = FCFileManager.urlForItem(atPath: localPath) else { return }
        let playerItem = AVPlayerItem.init(url: audioURL)
        let seconds = CMTimeGetSeconds(playerItem.asset.duration)
        let duration = Double(seconds)
        
        print("Saved duration: \(duration)")
        print("Path: \(localPath)")
        
        print(FCFileManager.urlForItem(atPath: localPath)!)
        
        //Store
        //        DatabaseManager.shared.createPremiumRingtone(name: ringtone.name,
        //                                                     duration: duration,
        //                                                     path: localPath)
        DatabaseManager.shared.create(name: ringtone.name,
                                      duration: duration,
                                      path: localPath)
        
    }
    
    class func exportRingtone(_ ringtone: RingToneModel, completion: ((Bool) -> Void)? = nil) {
        
        guard let lastPath = URL(string: ringtone.pathURL!)?.lastPathComponent else { return }
        let fromPath = FolderPath.ringtone + "/" + lastPath
        let toPath = ringtone.name + ".m4r"
        FCFileManager.removeItem(atPath: toPath)
        let status = FCFileManager.copyItem(atPath: fromPath, toPath: toPath)
        completion?(status)
    }
}
