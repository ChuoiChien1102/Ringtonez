//
//  DetailCategoryViewController.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 12/1/20.
//

import UIKit
import AVFoundation

class DetailCategoryViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbTitle: UILabel!
    
    var titleCategory = ""
    var categoryID = ""
    var ringtoneList = [RingToneModel]()
    var player: AVPlayer?
    var playerItem: AVPlayerItem!
    var timer: Timer?
    var cellSelected: Int?
    
    var currentPage = 1
    var last_page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "DetailCategoryCell", bundle: nil), forCellReuseIdentifier: "DetailCategoryCell")
        tableView.separatorStyle = .none
        lbTitle.text = titleCategory
        
        // load item ringtone
        var param = [String: Any]()
        param["app"] = "z"
        param["page"] = String(currentPage)
        param["cateID"] = categoryID
        
        LoadingManager.show(in: self)
        ApiSevice.detailCategory(param) { (response, error) in
            LoadingManager.hide()
            if (error == nil) {
                self.last_page = response!.last_page
                self.ringtoneList = (response?.data)!
                self.tableView.reloadData()
            }
        }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.pause()
        player = nil
    }

    @objc private func playerDidFinishPlaying(notification: NSNotification){
        print("Audio finished")
        timer?.invalidate()
        timer = nil
        let item = ringtoneList[cellSelected!]
        item.isPlay = false
        DispatchQueue.main.async { [self] in
            if let cell =
                self.tableView.cellForRow(at: IndexPath(row: cellSelected!,
                                                      section: 0)) as? DetailCategoryCell {
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
                                                          section: 0)) as? DetailCategoryCell {
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
            if PurchaserManager.checkListentedCounter() == false {
                let vc = IAPViewController.newInstance()
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
                return
            }
            do {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            }
            catch {
                print("Cannot play this song!")
            }
            guard let audioURL = URL.init(string: item.pathURL!)
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
            timer?.invalidate()
            timer = nil
            DispatchQueue.main.async { [self] in
                if let cell =
                    self.tableView.cellForRow(at: IndexPath(row: cellSelected!,
                                                          section: 0)) as? DetailCategoryCell {
                    cell.configUI(ringtone: item)
                }
              }
        }
        
    }
    
    @objc func clickDownload(sender: UIButton!) {
        if PurchaserManager.checkDownloadCounter() == false {
            let vc = IAPViewController.newInstance()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            return
        }
        let item = ringtoneList[sender.tag]
        guard let urlToDownload = URL.init(string: item.pathURL!) else { return }
        LoadingManager.show(in: self)
        ApiSevice.downloadFile(fileURL: urlToDownload, fileName: item.origin_url) { (filePath, isSuccess) in
            LoadingManager.hide()
            if isSuccess {
                //Save ringtone to Realm
                DNDownloadManager.store(ringtone: item)
                item.isDowloadDone = true
                self.tableView.reloadData()
            }
        }
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

extension DetailCategoryViewController: UITableViewDataSource, UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ringtoneList.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if ringtoneList.count > 0 && indexPath.row == ringtoneList.count - 1 && currentPage < last_page {
            // load more
            currentPage += 1
            var param = [String: Any]()
            param["app"] = "z"
            param["page"] = String(currentPage)
            param["cateID"] = categoryID
            
            LoadingManager.show(in: self)
            ApiSevice.detailCategory(param) { (response, error) in
                LoadingManager.hide()
                if (error == nil) {
                    guard let arr = response?.data else {return}
                    for item in arr {
                        self.ringtoneList.append(item)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCategoryCell")!as! DetailCategoryCell
        cell.btnPlay.tag = indexPath.row
        cell.btnDownload.tag = indexPath.row
        cell.btnPlay.addTarget(self, action: #selector(clickPlay), for: .touchUpInside)
        cell.btnDownload.addTarget(self, action: #selector(clickDownload), for: .touchUpInside)
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

extension DetailCategoryViewController: DatabaseUpdating {
    func createRingtone() {
        
    }
    
    func updateRingtone(id: String, newName: String) {
        
    }
    
    func deleteRingtone() {

    }
}
