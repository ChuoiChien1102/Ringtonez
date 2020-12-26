//
//  RingmakerView.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 11/23/20.
//

import Foundation
import SnapKit
import SoundWave
import AVFoundation
import Then

protocol RingmakerDelegate:class {
    
    func makerDidUpdateStartTime(startTime: Double, endTime: Double)
    func makerDidChange( startTrimTime: Double, trimDuration: Double)
}

class RingmakerView: View {
    
    var indicatorAnimateDuration: Double = 10
    
    var delegate: RingmakerDelegate?
    
    var url: URL?
    var audioDuration: Double = 120
    
    var limitDuration: Double = 10 {
        didSet {
            self.setBarPosition(by: limitDuration)
        }
    }
        
    private var baseDuration: Double = 0 {
        didSet {
            delegate?.makerDidUpdateStartTime(startTime: baseDuration, endTime: baseDuration + 30)
            delegate?.makerDidChange(startTrimTime: getStartTrimTime(), trimDuration: getTrimDuration())
        }
    }
    
    private(set) var maxDurationInScreen: CGFloat = 30
    
    private(set) var barWidth: CGFloat =  50
    
    //Wave
    private(set) var waveView: DKWaveView!
    
    //Bar
    private(set) var leftBar  = BaseBarView().then {
        $0.line.backgroundColor = UIColor.init(hex: "#0051FF")
        $0.line.roundCorners([.bottomLeft, .topLeft], radius: 10)
        $0.imageView.image = UIImage(named: "ic_Left_BarView")
        
    }
    private(set) var rightBar = BaseBarView().then {
        $0.line.backgroundColor = UIColor.init(hex: "#0051FF")
        $0.line.roundCorners([.bottomRight, .topRight], radius: 10)
        $0.imageView.image = UIImage(named: "ic_Right_BarView")
    }
    
    //Indicator
    private(set) var indicator = View().then {
        $0.backgroundColor = .red
    }
    
    private var centerArea = View().then {
        $0.backgroundColor = UIColor.init(hex: "#4D487C").withAlphaComponent(0.5)
        $0.borderColor = UIColor.init(hex: "#0051FF")
        $0.borderWidth = 0.5
    }
    
    init(url: URL? , frame: CGRect) {
        self.url = url
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func makeUI() {
        super.makeUI()
        readAudioFile()
        addWaveView()
        
        addBarView()

        addIndicatorView()
        addAreaView()
    }
    
    private func addWaveView() {
         
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        waveView = DKWaveView.init(url: url, audioDuration: self.audioDuration)
        waveView.baseDuration = {[weak self] _duration in
            guard let self = self else { return }
            self.baseDuration = _duration
        }
        
        self.addSubview(waveView)
        self.sendSubviewToBack(waveView)
        waveView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    
    private func addBarView() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        //Leftbar
        self.addSubview(leftBar)
        leftBar.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.center.equalTo(CGPoint.init(x: 25, y: self.frame.height / 2 ))
            make.width.equalTo(self.barWidth)
        }
                
        //Rightbar
        self.addSubview(rightBar)
        let limitSpace = CGFloat(limitDuration) * ((UIScreen.main.bounds.width - barWidth) / maxDurationInScreen )
        let newCenterRightBar = CGPoint.init(x: (25 + limitSpace) , y: leftBar.center.y)
        rightBar.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.center.equalTo(newCenterRightBar)
            make.width.equalTo(self.barWidth)
        }
                
        //Gesture
        let leftPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.leftDragged(_:)))
        leftBar.isUserInteractionEnabled = true
        leftBar.addGestureRecognizer(leftPanGesture)
        
        let rightPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.rightDragged(_:)))
        rightBar.isUserInteractionEnabled = true
        rightBar.addGestureRecognizer(rightPanGesture)

    }
    
    private func addIndicatorView() {
        
        self.addSubview(indicator)
        
        indicator.snp.makeConstraints { (make) in
            make.center.equalTo(self.leftBar.center)
            make.width.equalTo(2)
            make.top.bottom.equalToSuperview().inset(1)
        }
        
        indicator.isHidden = true
        
    }
    
    
    //MARK:- Gesture
    @objc private func leftDragged(_ sender: UIPanGestureRecognizer) {
        self.bringSubviewToFront(leftBar)
        let translation = sender.translation(in: self)
        var newCenter = CGPoint(x: leftBar.center.x + translation.x, y: leftBar.center.y)
        sender.setTranslation(CGPoint.zero, in: self)

        //Min
        if newCenter.x <= self.barWidth / 2 {
            newCenter = CGPoint(x: self.barWidth / 2, y: leftBar.center.y)
        }

        //Max
        if newCenter.x >= self.frame.width - barWidth - barWidth / 2 {
            newCenter = CGPoint(x: self.frame.width - barWidth - barWidth / 2, y: leftBar.center.y)
        }
        
        //Update center left bar when move leftbar
        leftBar.snp.remakeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.center.equalTo(newCenter)
            make.width.equalTo(self.barWidth)
        }
        
        //Update center rightbar when move leftbar to right && leftbar max == rightbar min
        if rightBar.center.x <= (leftBar.center.x + self.barWidth) {
            let newCenterRightBar = CGPoint.init(x: leftBar.center.x + self.barWidth, y: leftBar.center.y)
            rightBar.snp.remakeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.center.equalTo(newCenterRightBar)
                make.width.equalTo(self.barWidth)
            }
        }
        
        //when limit duration set
        //Caculator  by centerleft - centerright == self.frame.width - barWidth
        let limitSpace = CGFloat(limitDuration) * ((UIScreen.main.bounds.width - barWidth) / maxDurationInScreen )
        if rightBar.center.x >= (leftBar.center.x + limitSpace) {
            let newCenterRightBar = CGPoint.init(x: (leftBar.center.x + limitSpace) , y: leftBar.center.y)
            rightBar.snp.remakeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.center.equalTo(newCenterRightBar)
                make.width.equalTo(self.barWidth)
            }
        }
        
        delegate?.makerDidChange(startTrimTime: getStartTrimTime(), trimDuration: getTrimDuration())
    }
    
    @objc private func rightDragged(_ sender: UIPanGestureRecognizer) {
        self.bringSubviewToFront(rightBar)
        let translation = sender.translation(in: self)
        var newCenter = CGPoint(x: rightBar.center.x + translation.x, y: rightBar.center.y)
        sender.setTranslation(CGPoint.zero, in: self)

        //Max
        if newCenter.x >= self.frame.width - self.barWidth / 2 {
            newCenter = CGPoint(x: self.frame.width - self.barWidth / 2, y: rightBar.center.y)
        }
        
        //Min
        if newCenter.x <= barWidth + barWidth / 2 {
            newCenter = CGPoint(x: barWidth + barWidth / 2, y: rightBar.center.y)
        }
                
        //Update center right bar
        rightBar.snp.remakeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.center.equalTo(newCenter)
            make.width.equalTo(self.barWidth)
        }
                        
        //Update center rightbar when move leftbar to right && leftbar max == rightbar min
        if (rightBar.center.x <= (leftBar.center.x + self.barWidth)) {
            let newCenterLeftBar = CGPoint.init(x: rightBar.center.x - self.barWidth, y: rightBar.center.y)
            leftBar.snp.remakeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.center.equalTo(newCenterLeftBar)
                make.width.equalTo(self.barWidth)
            }
        }
        
        //when limit duration set
        //Caculator  by centerleft - centerright == self.frame.width - barWidth
        let limitSpace = CGFloat(limitDuration) * ((UIScreen.main.bounds.width - barWidth) / maxDurationInScreen )
        if rightBar.center.x >= (leftBar.center.x + limitSpace) {
            let newCenterLefttBar = CGPoint.init(x: (rightBar.center.x - limitSpace) , y: rightBar.center.y)
            leftBar.snp.remakeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.center.equalTo(newCenterLefttBar)
                make.width.equalTo(self.barWidth)
            }
        }
        
        delegate?.makerDidChange(startTrimTime: getStartTrimTime(), trimDuration: getTrimDuration())
    }
    
    func addAreaView() {
        
        self.addSubview(centerArea)
        
        centerArea.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(1)
            make.leading.equalTo(self.leftBar.snp.trailing).inset(25)
            make.trailing.equalTo(self.rightBar.snp.leading).inset(25)
        }
        
        self.bringSubviewToFront(leftBar)
        self.bringSubviewToFront(rightBar)
    }
    
    
    //MARK:- Function
    
    func getTrimDuration() -> Double {
        let persent =  (maxDurationInScreen / (UIScreen.main.bounds.width - barWidth))
        let space = rightBar.center.x - leftBar.center.x
        let duration = space * persent
        return Double(duration)
    }
    
    func getStartTrimTime() -> Double {
        var time: Double = 0
        
        let persent =  (maxDurationInScreen / (UIScreen.main.bounds.width - barWidth))
        
        let space = leftBar.center.x - barWidth / 2
        
        
        let duration = space * persent
        
        time = Double(duration) + Double(self.baseDuration)
        
        return time
    }
    
    func setBarPosition(by _duration: Double) {
        let limitSpace = CGFloat(_duration) * ((UIScreen.main.bounds.width - barWidth) / maxDurationInScreen )

        //Leftbar
        let leftBarCenter = CGPoint.init(x: barWidth / 2, y: self.frame.height / 2 )
        
        UIView.animate(withDuration: 0.3) {
            self.leftBar.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview()
                make.center.equalTo(leftBarCenter)
                make.width.equalTo(self.barWidth)
            }
            self.leftBar.updateConstraintsIfNeeded()
            self.layoutIfNeeded()
        }


        //RightBar
        let rightBarCenter = CGPoint.init(x: leftBarCenter.x + limitSpace, y: self.frame.height / 2)
        UIView.animate(withDuration: 0.3) {
            self.rightBar.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview()
                make.center.equalTo(rightBarCenter)
                make.width.equalTo(self.barWidth)
            }
            self.rightBar.updateConstraintsIfNeeded()
            self.layoutIfNeeded()
        }
        
        delegate?.makerDidChange(startTrimTime: getStartTrimTime(), trimDuration: getTrimDuration())
    }
    
    func readAudioFile() {

        guard let audioURL = self.url else { return }
        
        let asset = AVURLAsset(url: audioURL)
        let duration = Double(CMTimeGetSeconds(asset.duration))
        self.audioDuration = duration
        
    }
    
    func animateIndicator( animate: Bool ) {
        
        if animate {
            self.indicator.isHidden = false
            self.indicator.snp.updateConstraints { (make) in
                make.center.equalTo(self.leftBar.center)
                make.width.equalTo(2)
                make.top.bottom.equalToSuperview().inset(1)
            }
            self.layoutIfNeeded()
            self.indicator.updateConstraintsIfNeeded()
            UIView.animate(withDuration: indicatorAnimateDuration) {
                self.indicator.snp.updateConstraints { (make) in
                    make.center.equalTo(self.rightBar.center)
                    make.width.equalTo(2)
                    make.top.bottom.equalToSuperview().inset(1)
                }
                self.indicator.updateConstraintsIfNeeded()
                self.layoutIfNeeded()
            } completion: { (success) in
                self.indicator.isHidden = true
            }

            
        } else {
            self.indicator.layer.removeAllAnimations()
        }

    }
    
}
