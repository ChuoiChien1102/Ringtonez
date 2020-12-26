//
//  MyToneViewController.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 11/27/20.
//

import UIKit
import AVFoundation
import FCFileManager
import SDCAlertView
import SwiftNotificationCenter

class MyToneViewController: BaseViewController {

    @IBOutlet weak var viewPremium: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var ringtoneList = [RingToneModel]()
    var player: AVPlayer?
    var playerItem: AVPlayerItem!
    var timer: Timer?
    var cellSelected: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewPremium.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickPremium(_:)))
        viewPremium.addGestureRecognizer(tapGesture)
        
        tableView.register(UINib(nibName: "MyToneCell", bundle: nil), forCellReuseIdentifier: "MyToneCell")
        tableView.separatorStyle = .none
        
        Broadcaster.register(DatabaseUpdating.self, observer: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ringtoneList = DatabaseManager.shared.listRingMakerTones()
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.pause()
        player = nil
    }

    @objc private func playerDidFinishPlaying(notification: NSNotification){
        player = nil
        print("Audio finished")
        timer?.invalidate()
        timer = nil
        let item = ringtoneList[cellSelected!]
        item.isPlay = false
        DispatchQueue.main.async { [self] in
            if let cell =
                self.tableView.cellForRow(at: IndexPath(row: cellSelected!,
                                                      section: 0)) as? MyToneCell {
                cell.configUI(ringtone: item)
            }
        }
    }
    
    @objc func updateProgressView() {
        let duration =  playerItem.asset.duration
        let seconds = CMTimeGetSeconds(duration)
        let totalDuration = Double(seconds)
        
        if player?.currentItem?.status == .readyToPlay {
            let currentTime = CMTimeGetSeconds(self.player!.currentTime())
            let currentDuration: Double = Double(currentTime) <= 0 ? 0 : Double(currentTime)
            
            let item = ringtoneList[cellSelected!]
            item.progress = Float(currentDuration/totalDuration)
            DispatchQueue.main.async { [self] in
                if let cell =
                    self.tableView.cellForRow(at: IndexPath(row: cellSelected!,
                                                          section: 0)) as? MyToneCell {
                    cell.configUI(ringtone: item)
                }
              }
        }
    }
    
    @objc func clickPlay(sender: UIButton!) {
        // click cell khac thi reset
        if cellSelected != sender.tag {
            for item in ringtoneList {
                item.isSelected = false
                item.isPlay = false
                item.progress = 0
            }
            self.tableView.reloadData()
        }
        
        // play or pause cell click
        cellSelected = sender.tag
        let item = ringtoneList[sender.tag]
        item.isSelected = true
        item.isPlay = !item.isPlay
        
        if item.isPlay {
            let pathURL = item.pathURL
            do {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            }
            catch {
                print("Cannot play this song!")
            }
            guard let audioURL = FCFileManager.urlForItem(atPath: pathURL)
            else { print("cannot play audio!") ; return }
            let playerItem = AVPlayerItem.init(url: audioURL)
            self.player = AVPlayer.init(playerItem: playerItem)
            self.playerItem = playerItem
            self.player?.play()
            
            if timer == nil {
                timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: (#selector(self.updateProgressView)), userInfo: nil, repeats: true)
            }
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.playerDidFinishPlaying),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: self.player?.currentItem)
        } else {
            player?.pause()
            player = nil
            timer?.invalidate()
            timer = nil
            DispatchQueue.main.async { [self] in
                if let cell =
                    self.tableView.cellForRow(at: IndexPath(row: cellSelected!,
                                                          section: 0)) as? MyToneCell {
                    cell.configUI(ringtone: item)
                }
            }
        }
        
    }
    
    @objc func clickMore(sender: UIButton!) {
        let ringtone = ringtoneList[sender.tag]
        let alert = AlertController(title: "Choose your option to change", message: "\(ringtone.name)", preferredStyle: .actionSheet)
        
        alert.addAction(AlertAction(title: "Install ringtone", style: .normal, handler: {[weak self] action in
            guard let self = self else { return }
            DNDownloadManager.exportRingtone(ringtone) { (isSuccess) in
                if isSuccess == true {
                    LoadingManager.success(in: self)
                    let vc = TutorialViewController.newInstance()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }))

        alert.addAction(AlertAction(title: "Edit", style: .normal, handler: {[weak self] action in
            guard let self = self else { return }
            let vc = MakerViewController.newInstance()
            guard let urlString = ringtone.pathURL else { return }
            vc.audioPath = FCFileManager.urlForItem(atPath: urlString)
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        
        alert.addAction(AlertAction(title: "Delete", style: .destructive, handler: {[weak self] action in
            guard let self = self else { return }
            self.delete(item: ringtone)
        }))

        alert.addAction(AlertAction(title: "Cancel", style: .preferred))

        alert.present()
    }
    
    @objc func clickPremium(_ recognizer: UITapGestureRecognizer) {
        let vc = IAPViewController.newInstance()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func clickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension MyToneViewController {
    func delete(item: RingToneModel) -> Void {
        let alert = AlertController(title: "Are you sure delete this ringtone?", message: "The ringtone will lost", preferredStyle: .alert)
        alert.addAction(AlertAction(title: "Cancel", style: .normal))
        alert.addAction(AlertAction(title: "Delete", style: .destructive, handler: {[weak self] action in
            guard let self = self else { return }
            self.player?.pause()
            self.player = nil
            LoadingManager.show(in: self)
            DispatchQueue.main.async {
                DatabaseManager.shared.removeRingtone(id: item.databaseID!)
            }
        }))
        alert.present()
    }
}

extension MyToneViewController: UITableViewDataSource, UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ringtoneList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyToneCell")!as! MyToneCell
        cell.btnPlay.tag = indexPath.row
        cell.btnMore.tag = indexPath.row
        cell.btnPlay.addTarget(self, action: #selector(clickPlay), for: .touchUpInside)
        cell.btnMore.addTarget(self, action: #selector(clickMore), for: .touchUpInside)
        let item = ringtoneList[indexPath.row]
        cell.configUI(ringtone: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension MyToneViewController: DatabaseUpdating {
    func createRingtone() {
        
    }
    
    func updateRingtone(id: String, newName: String) {
        
    }
    
    func deleteRingtone() {
        // reload data
        LoadingManager.hide()
        ringtoneList = DatabaseManager.shared.listRingMakerTones()
        tableView.reloadData()
    }
}
