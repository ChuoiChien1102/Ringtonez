//
//  MakerViewController.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 11/13/20.
//

import UIKit
import AVFoundation
import FCFileManager
import SDCAlertView

class MakerViewController: BaseViewController {
    
    @IBOutlet weak var txtRingtoneName: UITextField!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnSave: UIView!
    
    @IBOutlet weak var rateSlider: UISlider!
    
    @IBOutlet weak var makerView: UIView!
    
    @IBOutlet weak var btn5s: UIButton!
    @IBOutlet weak var btn10s: UIButton!
    @IBOutlet weak var btn20s: UIButton!
    @IBOutlet weak var btn30s: UIButton!
    
    @IBOutlet weak var topContraintBtnSave: NSLayoutConstraint!
    
    @IBOutlet weak var heightContraintMakerView: NSLayoutConstraint!
    var startTimeLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "00:00"
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 10, weight: .regular)
    }
    
    var endTimeLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "30:00"
        $0.textAlignment = .right
        $0.font = UIFont.systemFont(ofSize: 10, weight: .regular)
    }
    
    var ringMakerView: RingmakerView!
    
    private var player: AVPlayer?
    
    var isPlay = false
    
    var rateValue: Double = 1.0 {
        didSet {
            speed = rateValue
        }
    }
    
    var audioName: String = ""
    var audioPath: URL?
    
    var enableFadein: Bool = false
    var enableFadeout: Bool = false
    
    var speed: Double = 1.0
    
    var startTrimTime: Double = 0
    var trimDuration: Double = 10
    
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
            return audioPath == nil ? getAudioTest() : audioPath
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if IS_IPHONE_5_5S_SE {
            heightContraintMakerView.constant = 80
            topContraintBtnSave.constant = 20
        } else if IS_IPHONE_6_6S_7_8 {
            heightContraintMakerView.constant = 160
            topContraintBtnSave.constant = 30
        } else if IS_IPHONE_6PLUS_7PLUS_8PLUS {
           
        } else if IS_IPHONE_X_XS {
            
        } else if IS_IPHONE_XR_XSMAX {
           
        } else {
            
        }
        
        btnSave.addGradient(colors: [UIColor.init(hex: "#1C51C0").cgColor, UIColor.init(hex: "#24D7F6").cgColor], cornerRadius: 10)
        btnSave.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickSave(_:)))
        btnSave.addGestureRecognizer(tapGesture)
        
        btnPlay.applyGradient(colors: [UIColor.init(hex: "#1C51C0").cgColor, UIColor.init(hex: "#24D7F6").cgColor])
        
        btn10s.applyGradient(colors: [UIColor.init(hex: "#1C51C0").cgColor, UIColor.init(hex: "#24D7F6").cgColor])
        
        ringMakerView = RingmakerView.init(url: self.audioURL, frame: makerView.frame)
        ringMakerView.delegate = self
        makerView.addSubview(ringMakerView)
        
        ringMakerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        //Add label
        makerView.addSubview(startTimeLabel)
        startTimeLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        
        makerView.addSubview(endTimeLabel)
        endTimeLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopAudio()
    }
    
    @objc func clickSave(_ recognizer: UITapGestureRecognizer) {
        LoadingManager.show(in: self)
        self.exportAudio { (isSuccess) in
            LoadingManager.hide()
            if isSuccess == true {
                DispatchQueue.main.async { [self] in
                    let alert = AlertController(title: "Success", message: "Save success", preferredStyle: .alert)
                    alert.addAction(AlertAction(title: "OK", style: .normal))
//                    alert.modalPresentationStyle = .fullScreen
                    alert.present()
                }
            } else {
                DispatchQueue.main.async { [self] in
                    let alert = AlertController(title: "Error", message: "Save failed", preferredStyle: .alert)
                    alert.addAction(AlertAction(title: "OK", style: .normal))
//                    alert.modalPresentationStyle = .fullScreen
                    alert.present()
                }
            }
        }
    }
    
    @IBAction func clickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickTutorial(_ sender: Any) {
        let vc = TutorialViewController.newInstance()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func clickPlay(_ sender: UIButton) {
        isPlay = !isPlay
        
        if isPlay {
            self.btnPlay.setImage(UIImage(named: "maker_play"), for: .normal)
            self.playAudio()
        } else {
            self.btnPlay.setImage(UIImage(named: "record_stop"), for: .normal)
            self.stopAudio()
        }
    }
    
    @IBAction func click5s(_ sender: Any) {
        btn5s.applyGradient(colors: [UIColor.init(hex: "#1C51C0").cgColor, UIColor.init(hex: "#24D7F6").cgColor])
        btn10s.removeGradient()
        btn20s.removeGradient()
        btn30s.removeGradient()
        
        ringMakerView.limitDuration = 5
        ringMakerView.indicatorAnimateDuration = 5
        ringMakerView.setBarPosition(by: 5)
    }
    
    @IBAction func click10s(_ sender: Any) {
        btn10s.applyGradient(colors: [UIColor.init(hex: "#1C51C0").cgColor, UIColor.init(hex: "#24D7F6").cgColor])
        btn5s.removeGradient()
        btn20s.removeGradient()
        btn30s.removeGradient()
        
        ringMakerView.limitDuration = 10
        ringMakerView.indicatorAnimateDuration = 10
        ringMakerView.setBarPosition(by: 10)
    }
    
    @IBAction func click20s(_ sender: Any) {
        if PurchaserManager.getIsPurchaser() == false {
            let vc = IAPViewController.newInstance()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            return
        }
        btn20s.applyGradient(colors: [UIColor.init(hex: "#1C51C0").cgColor, UIColor.init(hex: "#24D7F6").cgColor])
        btn10s.removeGradient()
        btn5s.removeGradient()
        btn30s.removeGradient()
        
        ringMakerView.limitDuration = 20
        ringMakerView.indicatorAnimateDuration = 20
        ringMakerView.setBarPosition(by: 20)
    }
    
    @IBAction func click30s(_ sender: Any) {
        if PurchaserManager.getIsPurchaser() == false {
            let vc = IAPViewController.newInstance()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            return
        }
        btn30s.applyGradient(colors: [UIColor.init(hex: "#1C51C0").cgColor, UIColor.init(hex: "#24D7F6").cgColor])
        btn10s.removeGradient()
        btn20s.removeGradient()
        btn5s.removeGradient()
        
        ringMakerView.limitDuration = 30
        ringMakerView.indicatorAnimateDuration = 30
        ringMakerView.setBarPosition(by: 30)
    }
    
    @IBAction func didChangeRateValue(_ sender: UISlider) {
        rateValue = Double(sender.value)
    }
    
    @IBAction func clickFadeIn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        enableFadein = !enableFadein
    }
    
    @IBAction func clickFadeOut(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        enableFadeout = !enableFadeout
    }
    
}

extension MakerViewController {
  
    
}

// MARK: - Audio
//
extension MakerViewController {
    
    private func getAudioTest() -> URL? {
        return Bundle.main.url(forResource: "audio", withExtension: "mp3")
    }
    
    func trimAudio(completed: @escaping () -> Void ) {
        guard let url = self.audioURL else {
            print("Cannot get ringtone URL")
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
        
        self.audioName = (self.txtRingtoneName.text == nil ? "" : self.txtRingtoneName.text)!
        func export() {
            //Auto create folder
            FCFileManager.createDirectories(forPath: FolderPath.ringtone)
            
            //Tmp path
            let fromPath = ".tmp/tmp.m4r"
            
            //New path
            let _uuid = UUID().uuidString.lowercased()
            let toPath = FolderPath.ringtone + "/" + (_uuid) + ".m4r"
            
            print("From: \(fromPath)")
            print("To: \(toPath)")
            
            //Move path
            let status = FCFileManager.copyItem(atPath: fromPath, toPath: toPath)
            
            if status == true {
                //Save item in database
                DispatchQueue.main.async {

                    let ring_name: String = self.audioName == "" ? "My Ringtone" : self.audioName
                    DatabaseManager.shared.create(name: ring_name,
                                                  duration: self.audioDuration,
                                                  path: toPath)
                    self.trimURL = nil
                }
            }
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
    
    
    func playAudio() {
        trimAudio {
            
            let url = self.trimURL
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
            self.playerItem = playerItem
            DispatchQueue.main.async {
                self.ringMakerView.indicatorAnimateDuration = self.audioDuration
                self.ringMakerView.animateIndicator(animate: true)
            }
            print("Start time: \(self.startTrimTime)")
            print("AudioDuration: \(self.audioDuration)")
            
            self.player?.play()
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.playerDidFinishPlaying),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: self.player?.currentItem)
        }
        
    }
    
    func stopAudio() {
        player?.pause()
        player = nil
        self.ringMakerView.animateIndicator(animate: false)
    }
    
    @objc private func playerDidFinishPlaying(notification: NSNotification){
        print("Audio finished")
        isPlay = false
        self.btnPlay.setImage(UIImage(named: "record_stop"), for: .normal)
    }
}

extension MakerViewController : AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }
}

extension MakerViewController: RingmakerDelegate {
    
    func makerDidUpdateStartTime(startTime: Double, endTime: Double) {
        self.startTimeLabel.text = startTime.toMS()
        self.endTimeLabel.text = endTime.toMS()
    }
    
    func makerDidChange(startTrimTime: Double, trimDuration: Double) {
        print("-->\(startTrimTime)  - \(trimDuration)")
        self.startTrimTime = startTrimTime
        self.trimDuration = trimDuration
    }
}
