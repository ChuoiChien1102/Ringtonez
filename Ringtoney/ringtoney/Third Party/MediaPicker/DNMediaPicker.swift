//
//  DNMediaPicker.swift
//  ringtoney
//
//  Created by dong ka on 01/12/2020.
//

import Foundation
import UIKit
import MediaPlayer
import SwiftNotificationCenter

protocol MediaPickerUpdate {
    func tunesMakerDidPickAudio(_ mediaObject: [String : Any]?)
}

class DNMediaPicker: NSObject {
    
    var rootViewController: UIViewController!
    
    static let shared : DNMediaPicker = {
        let instance = DNMediaPicker()
        return instance
    }()
    
    override init() {
        super.init()
    }
    
    func presentMediaPicker () {
        
        let picker = MPMediaPickerController(mediaTypes:.music)
        picker.showsCloudItems = false
        picker.delegate = self
        picker.showsItemsWithProtectedAssets = false
        picker.allowsPickingMultipleItems = false
        picker.prompt = "Choose item to import"
        picker.popoverPresentationController?.sourceView = self.rootViewController.view
        picker.popoverPresentationController?.sourceRect = CGRect(x: self.rootViewController.view.bounds.midX, y: self.rootViewController.view.bounds.midY, width: 0, height: 0)
        picker.popoverPresentationController?.permittedArrowDirections = []
        rootViewController.present(picker, animated: true)
        
    }
    
    func export(_ assetURL: URL, completionHandler: @escaping (_ fileURL: URL?, _ error: Error?) -> ()) {
        
        let asset = AVURLAsset(url: assetURL)
        guard let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
            completionHandler(nil, ExportError.unableToCreateExporter)
            return
        }
        
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(NSUUID().uuidString)
            .appendingPathExtension("m4r")
        
        exporter.outputURL = fileURL
        exporter.outputFileType = AVFileType(rawValue: "com.apple.m4a-audio")
        
        exporter.exportAsynchronously {
            if exporter.status == .completed {
                completionHandler(fileURL, nil)
            } else {
                completionHandler(nil, exporter.error)
            }
        }
    }
    
    func assetMediaItem(with mediaItem: MPMediaItem, title:String, artist:String, completion:@escaping () -> Void) {
        if let assetURL = mediaItem.assetURL {
            DispatchQueue.main.async {
                LoadingManager.show(in: self.rootViewController)
            }
            export(assetURL) { fileURL, error in
                guard let fileURL = fileURL, error == nil else {
                    print("Error ", error ?? "")
                    return
                }
                DispatchQueue.main.async {
                    
                    let mediaObject = ["mediaUrl" : fileURL, "title" : title, "artist": artist] as [String : Any]
                    
                    log.debug(mediaObject)
                    
                    Broadcaster.notify(MediaPickerUpdate.self) {
                        $0.tunesMakerDidPickAudio(mediaObject)
                    }
                    
                    LoadingManager.hide()
                    completion()
                }
            }
        } else {
            print("Asset Mediation 100: Error cmnr")
        }
    }
    
    
    enum ExportError: Error {
        case unableToCreateExporter
    }
}

extension DNMediaPicker : MPMediaPickerControllerDelegate{
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        guard let mediaItem = mediaItemCollection.items.first else {
            NSLog("No item selected.")
            return
        }
        
        self.rootViewController.dismiss(animated:true)
        
        var title:String = "Unknown"
        
        if let ti:String = mediaItem.value(forProperty: MPMediaItemPropertyTitle) as? String{
            title = ti
        }else{
            title = "Unknown"
        }
        
        var artist = "Unknown"
        if let art = mediaItem.value(forKey: MPMediaItemPropertyArtist) as? String {
            artist = art
        }
        
        
        self.assetMediaItem(with: mediaItem, title: title, artist: artist, completion: {
            
        })
        print("Pick music success")
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        print("cancel")
        self.rootViewController.dismiss(animated:true)
    }
    
    
    
}
