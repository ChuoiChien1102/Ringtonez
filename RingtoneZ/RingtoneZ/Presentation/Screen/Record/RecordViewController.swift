//
//  RecordViewController.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 11/11/20.
//

import UIKit
import AVFoundation

class RecordViewController: BaseViewController {
    
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var viewClickRecord: UIView!
    @IBOutlet weak var imgRecord: UIImageView!
    
    @IBOutlet weak var lbTapRecord: UILabel!
    
    @IBOutlet weak var viewPremium: UIView!
    
    @IBOutlet weak var makerRingTone: UIButton!
    @IBOutlet weak var reRecord: UIButton!
    @IBOutlet weak var lbMakerRingTone: UILabel!
    @IBOutlet weak var lbReRecord: UILabel!
    
    @IBOutlet weak var topContraintBtnMaker: NSLayoutConstraint!
    
    var circle = CAShapeLayer()
    var drawAnimation = CABasicAnimation()
    var isRecordStatus = 0 // record nil
    var isRecordPause = false
    
    var seconds = 0
    var timer: Timer?
    var audioPath: URL?
    
    var timeDurationRecord = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if IS_IPHONE_5_5S_SE {
            topContraintBtnMaker.constant = 20;
        } else if IS_IPHONE_6_6S_7_8 {
            
        } else if IS_IPHONE_6PLUS_7PLUS_8PLUS {
            
        } else if IS_IPHONE_X_XS {
            
        } else if IS_IPHONE_XR_XSMAX {
            
        } else {
            
        }
        
        viewPremium.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickPremium(_:)))
        viewPremium.addGestureRecognizer(tapGesture)
        
        viewClickRecord.isUserInteractionEnabled = true
        let tapGestureRecord = UITapGestureRecognizer(target: self, action: #selector(clickRecord(_:)))
        viewClickRecord.addGestureRecognizer(tapGestureRecord)
        
        makerRingTone.isHidden = true
        lbMakerRingTone.isHidden = true
        reRecord.isHidden = true
        lbReRecord.isHidden = true
        
        AudioRecorderManager.shared.requestRecordPermission { (isAllow) in
            if isAllow == false {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func clickPremium(_ recognizer: UITapGestureRecognizer) {
        let vc = IAPViewController.newInstance()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func clickRecord(_ recognizer: UITapGestureRecognizer) {
        if isRecordStatus == 0 {
            isRecordStatus = 1
            imgRecord.image = UIImage(named: "record_play")
            UIView.transition(with: lbTapRecord, duration: 0.4,
                              options: .transitionFlipFromBottom,
                              animations: {
                                self.lbTapRecord.text = "Recording..."
                              })
            addCircleAnimation()
        } else if isRecordStatus == 1 {
            isRecordStatus = 2
            imgRecord.image = UIImage(named: "record_stop")
            UIView.transition(with: lbTapRecord, duration: 0.4,
                              options: .transitionFlipFromBottom,
                              animations: {
                                self.lbTapRecord.text = "Record finish"
                              })
            stopCircleAnimation()
        } else if isRecordStatus == 2 {
            
        }
    }
    
    @IBAction func clickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickMakerRingTone(_ sender: Any) {
        let vc = MakerViewController.newInstance()
        vc.audioPath = audioPath
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickReRecord(_ sender: Any) {
        seconds = 0
        lbTime.text = timeString(time: TimeInterval(seconds))
        isRecordStatus = 0
        imgRecord.image = UIImage(named: "record1")
        circle.removeFromSuperlayer()
        UIView.transition(with: lbTapRecord, duration: 0.4,
                          options: .transitionFlipFromBottom,
                          animations: {
                            self.lbTapRecord.text = "Tap to record"
                          })
        UIView.transition(with: makerRingTone, duration: 0.4,
                          options: .transitionFlipFromBottom,
                          animations: {
                            self.makerRingTone.isHidden = true
                          })
        UIView.transition(with: lbMakerRingTone, duration: 0.4,
                          options: .transitionFlipFromBottom,
                          animations: {
                            self.lbMakerRingTone.isHidden = true
                          })
        UIView.transition(with: reRecord, duration: 0.4,
                          options: .transitionFlipFromBottom,
                          animations: {
                            self.reRecord.isHidden = true
                          })
        UIView.transition(with: lbReRecord, duration: 0.4,
                          options: .transitionFlipFromBottom,
                          animations: {
                            self.lbReRecord.isHidden = true
                          })
    }
    
}

extension RecordViewController {
    
    func addCircleAnimation() {
        let radius = min(circleView.bounds.width, circleView.bounds.height) / 2
        circle.strokeColor = UIColor.white.cgColor
        circle.fillColor = UIColor.clear.cgColor
        circle.lineWidth = radius/16
        circleView.layer.addSublayer(circle)
        
        let rect = CGRect(x: 0, y: 0, width: 2*radius, height: 2*radius)
        let roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        circle.path = roundedRect.cgPath
        circle.strokeEnd = 1
        circle.speed = 1.0
        
        drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.fromValue = 0
        drawAnimation.toValue = 1
        drawAnimation.duration = CFTimeInterval(timeDurationRecord)
        drawAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        circle.add(drawAnimation, forKey: "drawCircleAnimation")
        
        runTimer()
        AudioRecorderManager.shared.startRecording()
    }
    
    func resumeCircleAnimation() {
        let pausedTime = circle.timeOffset;
        circle.speed = 1.0;
        circle.timeOffset = 0.0;
        circle.beginTime = 0.0;
        var timeSincePause = CFTimeInterval()
        timeSincePause = circle.convertTime(CACurrentMediaTime(), from: nil) - pausedTime;
        circle.beginTime = timeSincePause;
        
        runTimer()
        AudioRecorderManager.shared.startRecording()
    }
    
    func stopCircleAnimation() {
        var pausedTime = CFTimeInterval()
        pausedTime = circle.convertTime(CACurrentMediaTime(), from: nil)
        circle.speed = 0.0;
        circle.timeOffset = pausedTime;
        
        timer!.invalidate()
        timer = nil
        AudioRecorderManager.shared.finishRecording(isSuccess: true) { [weak self] (isSuccess, fileURLPatch)  in
            if isSuccess == true {
                self?.audioPath = fileURLPatch
                UIView.transition(with: (self?.makerRingTone)!, duration: 0.4,
                                  options: .transitionFlipFromBottom,
                                  animations: {
                                    self?.makerRingTone.isHidden = false
                                  })
                UIView.transition(with: (self?.lbMakerRingTone)!, duration: 0.4,
                                  options: .transitionFlipFromBottom,
                                  animations: {
                                    self?.lbMakerRingTone.isHidden = false
                                  })
                UIView.transition(with: (self?.reRecord)!, duration: 0.4,
                                  options: .transitionFlipFromBottom,
                                  animations: {
                                    self?.reRecord.isHidden = false
                                  })
                UIView.transition(with: (self?.lbReRecord)!, duration: 0.4,
                                  options: .transitionFlipFromBottom,
                                  animations: {
                                    self?.lbReRecord.isHidden = false
                                  })
            } else {
                // recording failed :(
            }
        }
    }
    
    
    func runTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateTimer() {
        seconds += 1
        // nếu chưa phải premium thì cho thu âm tối đa 10s
        if seconds > 10 {
            if (PurchaserManager.getIsPurchaser() == false) {
                isRecordStatus = 2
                imgRecord.image = UIImage(named: "record_stop")
                UIView.transition(with: lbTapRecord, duration: 0.4,
                                  options: .transitionFlipFromBottom,
                                  animations: {
                                    self.lbTapRecord.text = "Record finish"
                                  })
                stopCircleAnimation()
                return
            }
        }
        lbTime.text = timeString(time: TimeInterval(seconds))
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
}
