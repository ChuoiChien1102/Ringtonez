//
//  AudioRecorderManager.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 12/5/20.
//

import Foundation
import AVFoundation

final class AudioRecorderManager: NSObject {
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    static let shared = AudioRecorderManager()
    
    func requestRecordPermission(completion: ((Bool) -> Void)? = nil) {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [weak self] allowed in
                completion?(allowed)
            }
        } catch {
            // failed to record
            completion?(false)
        }
    }
    
    func startRecording() {
        
        //1. create the session
        let session = AVAudioSession.sharedInstance()
        
        do {
            // 2. configure the session for recording and playback
            try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
            try session.setActive(true)
            // 3. set up a high-quality recording session
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            // 4. create the audio recording, and assign ourselves as the delegate
            audioRecorder = try AVAudioRecorder(url: getFileURL(), settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            //5. Changing record icon to stop icon
            
        }
        catch let error {
            // failed to record!
            print(error)
        }
    }
    
    func finishRecording(isSuccess: Bool, completion: ((_ isSucces: Bool, _ filePath: URL?) -> Void)? = nil) {
        audioRecorder.stop()
        audioRecorder = nil
        
        completion?(isSuccess, getFileURL())
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL() -> URL {
        let path = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        return path as URL
    }
}

extension AudioRecorderManager: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(isSuccess: false)
        }
        print("Audio Recorder finished successfully")
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Recorder error")
    }
}
