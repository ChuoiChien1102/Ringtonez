//
//  RecordViewController.swift
//  ringtoney
//
//  Created by dong ka on 11/10/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SoundWave
import Permission

class RecordViewController: ViewController, PermissionSetDelegate {
    
    //MARK:- Property
    var backNavigationView = BackNavigationView()
    
    var timerLabel = Label().then {
        $0.text = "00:00"
        $0.font = FontsManager.nasalization.font(size: 34)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    var recordButton = Button().then {
        $0.setImage(R.image.icon_button_record(), for: .normal)
        //        $0.setImage(R.image.icon_button_recordagain(), for: .selected)
    }
    
    var recordControlView = RecordControlView()
    
    //Waveview
    
    var audioVisualizationView: AudioVisualizationView!
    
    private let waveViewModel = WaveViewModel()
    
    enum AudioRecodingState {
        case ready
        case recording
        case recorded
        case playing
        case paused
        
        var audioVisualizationMode: AudioVisualizationView.AudioVisualizationMode {
            switch self {
            case .ready, .recording:
                return .write
            case .paused, .playing, .recorded:
                return .read
            }
        }
    }
    
    private var currentState: AudioRecodingState = .ready {
        didSet {
            self.audioVisualizationView.audioVisualizationMode = self.currentState.audioVisualizationMode
            
            switch currentState {
            case .ready:
                self.recordButton.setImage(R.image.icon_button_record(), for: .normal)
            case .recording:
                self.recordButton.setImage(R.image.icon_button_stoprecord(), for: .normal)
            default:
                self.recordButton.setImage(R.image.icon_button_recordagain(), for: .normal)
            }
            
        }
    }
    
    private var chronometer: Chronometer? {
        didSet {
            chronometer?.timerDidUpdate = { [weak self] timerInterval in
                self?.timerLabel.text = timerInterval.stringFromTimeInterval()
            }
        }
    }
    
    let finishPlayAudio = PublishSubject<Void>.init()
    var __isPlaying = false
    
    //Permission
    let permission: Permission = .microphone
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ENTER YOUR TITLE HERE"
        //Code here
        
        self.waveViewModel.askAudioRecordingPermission()
        
        self.waveViewModel.audioMeteringLevelUpdate = { [weak self] meteringLevel in
            guard let self = self, self.audioVisualizationView.audioVisualizationMode == .write else {
                return
            }
            self.audioVisualizationView.add(meteringLevel: meteringLevel)
        }
        
        self.waveViewModel.audioDidFinish = { [weak self] in
            self?.currentState = .recorded
            self?.audioVisualizationView.stop()
            self?.recordControlView.playButton.isSelected = false
            self?.finishPlayAudio.onNext(())
            self?.__isPlaying = false
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Code here
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Code here
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Code here
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //Code here
    }
    
    
    //MARK:- Deinit
    deinit {
        log.debug("\(type(of: self)): Deinited")
    }
    
    //MARK:- Bind ViewModel
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel as? RecordViewModel else { return }
        
        //Input
        let inputs = RecordViewModel.Input(
            dismiss: backNavigationView.backButton.rx.tap.asObservable(),
            makerTrigger: recordControlView.makerButton.rx.tap.asObservable(),
            saveTrigger: recordControlView.saveButton.rx.tap.asObservable(),
            playPauseTrigger: recordControlView.playButton.rx.tap.asObservable(),
            finishPlayAudio: finishPlayAudio.asObserver()
        )
        
        //Outputs
        let output = viewModel.transform(input: inputs)
        
        output.isPlay
            .drive(recordControlView.playButton.rx.isSelected)
            .disposed(by: bag)
        
        recordControlView.playButton.rx.tap
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                if self.__isPlaying {
                    self.pauseRecord()
                } else {
                    self.playRecord()
                }
                self.__isPlaying = !self.__isPlaying
            })
            .disposed(by: bag)
        
    }
    
    //MARK:- UI
    override func makeUI() {
        super.makeUI()
        //Code here
        addNavigationView()
        addTimerLabel()
        addWaveView()
        addRecordButton()
        addAudioControlView()
        
    }
    
    override func updateUI() {
        
    }
    
    func addNavigationView() {
        stackView.addArrangedSubview(backNavigationView)
        backNavigationView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
        backNavigationView.titleLabel.text = "New Recording"
    }
    
    func addTimerLabel() {
        let container = View()
        container.backgroundColor = .clear
        stackView.addArrangedSubview(container)
        container.snp.makeConstraints { (make) in
            make.height.equalTo(130)
        }
        
        container.addSubview(timerLabel)
        timerLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
    }
    
    func addWaveView() {
        let container = View()
        container.backgroundColor = .clear
        stackView.addArrangedSubview(container)
        
        audioVisualizationView = AudioVisualizationView.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.width, height: 500))
        
        audioVisualizationView.backgroundColor = .clear
        
        container.addSubview(audioVisualizationView)
        audioVisualizationView.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(self.view.frame.width / 2)
        }
        log.debug(audioVisualizationView.frame.height)
        self.audioVisualizationView.meteringLevelBarWidth = 4.0
        self.audioVisualizationView.meteringLevelBarInterItem = 2.0
        self.audioVisualizationView.meteringLevelBarCornerRadius = 2.0
        
        self.timerLabel.text = String(format: "%.2f", 0)
        
        
    }
    
    func addRecordButton() {
        let container = View()
        container.backgroundColor = .clear
        stackView.addArrangedSubview(container)
        container.snp.makeConstraints { (make) in
            make.height.equalTo(130)
        }
        
        container.addSubview(recordButton)
        recordButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(115)
        }
        recordButton.tag = 1
        
        recordButton.addTarget(self, action: #selector(buttonActionTouchDown), for: .touchDown)
        recordButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        
    }
    
    func addAudioControlView() {
        let container = View()
        container.backgroundColor = .clear
        stackView.addArrangedSubview(container)
        container.snp.makeConstraints { (make) in
            make.height.equalTo(130)
        }
        
        container.addSubview(recordControlView)
        recordControlView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(80)
        }
        
        animateView(v: recordControlView, isHidden: true, isAnimate: false)
        
        recordControlView.saveButton.rx.tap
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                LoadingManager.success(in: self)
            })
            .disposed(by: bag)
        
        
    }
    
    //MARK:- Action
    @objc func buttonActionTouchDown(sender: UIButton!) {
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        let btnsendtag: UIButton = sender
        if btnsendtag.tag == 1 {
            checkMicrophonePermission(completed: {
                
                switch self.currentState {
                case .ready:
                    self.startRecord()
                case .recording:
                    self.stopRecord()
                case .recorded, .paused:
                    self.reset()
                case .playing:
                    self.reset()
                }
            })
        }
    }
    
    func startRecord() {
        self.waveViewModel.startRecording { [weak self] soundRecord, error in
            if let error = error {
                self?.showAlert(with: error)
                return
            }
            
            self?.currentState = .recording
            
            self?.chronometer = Chronometer(withTimeInterval: 1)
            self?.chronometer?.start()
        }
        
        animateView(v: recordControlView, isHidden: true, isAnimate: true)

    }
    
    func stopRecord() {
        self.chronometer?.stop()
        self.chronometer = nil
        
        self.audioVisualizationView.snp.remakeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(self.view.frame.width)
        }
        
        self.audioVisualizationView.setNeedsDisplay()
        
        
        self.waveViewModel.currentAudioRecord!.meteringLevels = self.audioVisualizationView.scaleSoundDataToFitScreen()
        self.audioVisualizationView.audioVisualizationMode = .read
        
        do {
            try self.waveViewModel.stopRecording()
            self.currentState = .recorded
        } catch {
            self.currentState = .ready
            self.showAlert(with: error)
        }
        
        animateView(v: recordControlView, isHidden: false, isAnimate: true)
        
    }
    
    func playRecord() {
        do {
            let duration = try self.waveViewModel.startPlaying()
            self.currentState = .playing
            self.audioVisualizationView.meteringLevels = self.waveViewModel.currentAudioRecord!.meteringLevels
            self.audioVisualizationView.play(for: duration)
        } catch {
            self.showAlert(with: error)
        }
    }
    
    func pauseRecord() {
        do {
            try self.waveViewModel.pausePlaying()
            self.currentState = .paused
            self.audioVisualizationView.pause()
        } catch {
            //            self.showAlert(with: error)
            log.error(error)
        }
    }
    
    func reset() {
        pauseRecord()
        do {
            try self.waveViewModel.resetRecording()
            self.audioVisualizationView.reset()
            self.currentState = .ready
        } catch {
            self.showAlert(with: error)
        }
    }
    
    func checkMicrophonePermission(completed: @escaping () -> Void) {
        permission.request { status in
            switch status {
            case .authorized:
                print("authorized")
                completed()
            case .denied:
                print("denied")
            case .disabled:
                print("disabled")
            case .notDetermined:
                print("not determined")
            }
        }
    }
    
    func animateView( v: View, isHidden: Bool, isAnimate: Bool) {
        let translationY = isHidden ?  CGAffineTransform.init(translationX: v.center.x, y: 1000) : .identity
        if isAnimate {
            UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [.curveEaseInOut]) {
                //Code
                v.transform = translationY
            } completion: { (success) in
                //Code
            }
        } else {
            v.transform = translationY
        }
    }
    
}

//MARK:- Extensition
extension RecordViewController {
    
    
    
    
    
}
