//
//  DKWaveView.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 11/23/20.
//

import Foundation
import SnapKit
import SoundWave
import AVFoundation

class DKWaveView : View, UIScrollViewDelegate {
    
    var baseDuration : ((Double) -> Void)?

    fileprivate var offSet:CGFloat = 0.0 {
        didSet {
            let persent = maxDurationInScreen /  UIScreen.main.bounds.width
            var d = Double(offSet * persent)
            d = d <= 0 ? 0 : d
            baseDuration?(d)
        }
    }
    
    
    private(set) var visualBackgroundColor: UIColor = .clear
    private(set) var maxDurationInScreen: CGFloat = 30

    private(set) var audioDuration: Double
    private(set) var audioURL: URL?
    
    private(set) var meteringLevelBarWidth: CGFloat = 4
    private(set) var meteringLevelBarInterItem: CGFloat = 2
    
    private(set) var audioVisualizationView: AudioVisualizationView!
    
    private(set) var scrollView : UIScrollView = UIScrollView()
    
//    init(duration: Double) {
//        audioDuration = duration
//        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//    }
    
    init(url: URL?, audioDuration: Double) {
        self.audioDuration = audioDuration
        self.audioURL = url
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented"); }
    
    override func makeUI() {
        super.makeUI()
        addScrollView()
        addAudioVisualizationView()
    }
    
    private func addScrollView() {
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        scrollView.delegate = self
    }
    
    
    private func addAudioVisualizationView(){
        
//        guard let path = Bundle.main.path(forResource: "audio2", ofType:"mp3") else {
//            fatalError("Couldn't find the file path")
//        }

        audioVisualizationView = AudioVisualizationView.init(frame: .zero)
        audioVisualizationView.backgroundColor = visualBackgroundColor
            
        //Caculator visualview width
        let screenWidth = UIScreen.main.bounds.width
        
        let audioVisualizationViewWidth = (CGFloat(self.audioDuration) / 30.0) * screenWidth

        scrollView.addSubview(audioVisualizationView)
        audioVisualizationView.snp.makeConstraints { (make) in
            make.width.equalTo(audioVisualizationViewWidth)
            make.height.equalToSuperview()
        }
        print(audioVisualizationViewWidth)
        scrollView.contentSize = CGSize.init(width: audioVisualizationViewWidth, height: scrollView.frame.height)
        
        self.audioVisualizationView.meteringLevelBarWidth = meteringLevelBarWidth
        self.audioVisualizationView.meteringLevelBarInterItem = meteringLevelBarInterItem
        self.audioVisualizationView.meteringLevelBarCornerRadius = 2.0

        guard let url = self.audioURL else {
            print("Cannot get this audio URL")
            return }
        
        var outputArray : [Float] = []
        AudioContext.load(fromAudioURL: url , completionHandler: { audioContext in
            guard let audioContext = audioContext else {
                fatalError("Couldn't create the audioContext")
            }
            outputArray = render(audioContext: audioContext, targetSamples: Int(audioVisualizationViewWidth) / Int((self.meteringLevelBarWidth + self.meteringLevelBarInterItem )))
            //log.debug("Sample array: \(outputArray.count)")
            //log.debug("End: \(Date().toString(format: .custom("hh:mm:ss")))")
            DispatchQueue.main.async {
                let newArray = outputArray.map { (abs($0) / 100) }
                self.audioVisualizationView.meteringLevels = newArray
                self.audioVisualizationView.gradientStartColor = UIColor.init(hex: "#ffffff")
                self.audioVisualizationView.gradientEndColor = UIColor.init(hex: "#ffffff")
                self.audioVisualizationView.audioVisualizationMode = .read
                self.audioVisualizationView.play(for: 0.0)
            }
            
        })

        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        offSet = scrollView.contentOffset.x
    }

}
