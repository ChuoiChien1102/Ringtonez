//
//  RingMakerViewController.swift
//  ringtoney
//
//  Created by dong ka on 11/12/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SoundWave

class RingMakerViewController: ViewController {
    
    //MARK:- Property
    var backNavigationView = BackNavigationView()
    
    //Rename
    var makerTextFieldView = MakerTextFieldView()
    
    //FadeView
    var makerFadeInOutView = MakerFadeInOutView()
    
    //SoundAdjustVieq
    var makerSoundAdjustView = MakerSoundAdjustView()
    
    //ControlView
    var makerControlView = MakerControlView()
    
    
    //MakerView
    var limitDurationView: LimitDurationView!
    var makerView: RingmakerView!
    var makerViewContainer = View()
    
    
    //Publish subject
    var subjectStartTrimTime = PublishSubject<Double>.init()
    var subjectTrimDuration = PublishSubject<Double>.init()
    
    
    var startTimeLabel = Label().then {
        $0.textColor = .white
        $0.text = "00:00"
        $0.font = FontsManager.nasalization.font(size: 10)
        $0.textAlignment = .left
    }
    
    var endTimeLabel = Label().then {
        $0.textColor = .white
        $0.text = "00:00"
        $0.font = FontsManager.nasalization.font(size: 10)
        $0.textAlignment = .right
    }
    
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ENTER YOUR TITLE HERE"
        //Code here
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    //MARK:- Deinit
    deinit {
        log.debug("\(type(of: self)): Deinited")
    }
    
    //MARK:- Bind ViewModel
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel as? RingMakerViewModel else { return }
        
        self.makerView.makerModel = viewModel.makerModel
        
        //Input
        let inputs = RingMakerViewModel.Input(
            dismiss: backNavigationView.backButton.rx.tap.asObservable(),
            set10sec: limitDurationView.btn10sec.rx.tap.asObservable(),
            set20sec: limitDurationView.btn20sec.rx.tap.asObservable(),
            set30sec: limitDurationView.btn30sec.rx.tap.asObservable(),
            set40sec: limitDurationView.btn40sec.rx.tap.asObservable(),
            fadeInTrigger: makerFadeInOutView.fadeinButton.rx.tap.asObservable(),
            fadeOutTrigger: makerFadeInOutView.fadeoutButton.rx.tap.asObservable(),
            startTrimTime: self.subjectStartTrimTime.asObserver(),
            trimDuration: self.subjectTrimDuration.asObserver(),
            soundEffectTrigger: self.makerSoundAdjustView.slider.rx.value.asObservable(),
            playTrigger: makerControlView.playButton.rx.tap.asObservable(),
            renameTrigger: self.makerTextFieldView.textFied.rx.text.asObservable(),
            saveTrigger: self.makerControlView.saveButton.rx.tap.asObservable(),
            tutorialTrigger: self.makerControlView.tutorialButton.rx.tap.asObservable(),
            premiumTrigger: backNavigationView.premiumButton.rx.tap.asObservable()
        )
        
        //Outputs
        let output = viewModel.transform(input: inputs)
        
        output.limitDuration
            .compactMap{$0}
            .drive(onNext:{[weak self] duration in
                guard let self = self else { return }
                self.makerView.limitDuration = duration
            })
            .disposed(by: bag)
        
        output.limitDuration
            .compactMap{$0}
            .drive(limitDurationView.limitDuration)
            .disposed(by: bag)
        
        makerControlView.playButton.rx.tap
            .subscribe(onNext:{ _ in
                
                let t = self.makerView.getStartTrimTime()
                let f = self.makerView.getTrimDuration()
                
                log.debug("Trim \(t) -> \(f)")
                
            })
            .disposed(by: bag)
        
        output.fadeIn
            .drive(makerFadeInOutView.enableFadeIn)
            .disposed(by: bag)
        
        output.fadeOut
            .drive(makerFadeInOutView.enableFadeOut)
            .disposed(by: bag)
        
        
        output.isPlay
            .drive(makerControlView.playButton.rx.isSelected)
            .disposed(by: bag)
        
        output.isPlay
            .drive(onNext:{[weak self] _isPlay in
                guard let self = self else { return }
                self.makerView.animateIndicator(animate: _isPlay)
            })
            .disposed(by: bag)
        
        //Need fix
        output.animateDuration
            .bind(to: makerView.indicatorAnimateDuration)
            .disposed(by: bag)
        
        output.makerStatus
            .compactMap{$0}
            .drive(onNext:{[weak self] _status in
                guard let self = self else { return }
                switch _status {
                case .success:
                    LoadingManager.success(in: self)
                    break
                case .error:
                    break
                }
            })
            .disposed(by: bag)
        
        output.showLoading
            .drive(onNext:{[weak self] _status in
                guard let self = self else { return }
                if _status {
                    LoadingManager.show(in: self)
                } else{
                    LoadingManager.hide()
                }
                
            })
            .disposed(by: bag)
        
    }
    
    //MARK:- UI
    override func makeUI() {
        super.makeUI()
        //Code here
        
        stackView.spacing = 8
        
        //
        addNavigationView()
        addTextField()
        addLimitDuratiomContainer()
        addRingMakerContainerView()
        addFadeInOut()
        addSoundSpeedContainer()
        addControlContainer()
        
        self.view.setNeedsLayout()
        self.view.setNeedsUpdateConstraints()
        
        addMakerView()
    }
    
    override func updateUI() {
        
    }
    
    func addNavigationView() {
        stackView.addArrangedSubview(backNavigationView)
        backNavigationView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
        backNavigationView.titleLabel.text = ""
        backNavigationView.isHiddenPremiumButton = false
    }
    
    func addTextField() {
        let container = View()
        container.backgroundColor = .clear
        stackView.addArrangedSubview(container)
        container.snp.makeConstraints { (make) in
            make.height.equalTo(70)
        }
        
        container.addSubview(makerTextFieldView)
        makerTextFieldView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
        }
        
    }
    
    func addLimitDuratiomContainer() {
        limitDurationView = LimitDurationView()
        stackView.addArrangedSubview(limitDurationView)
        limitDurationView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
    }
    
    func addRingMakerContainerView() {
        stackView.addArrangedSubview(makerViewContainer)
    }
    
    func addFadeInOut() {
        let container = View()
        container.clipsToBounds = false
        container.backgroundColor = .clear
        stackView.addArrangedSubview(container)
        container.snp.makeConstraints { (make) in
            make.height.equalTo(80)
        }
        
        container.addSubview(makerFadeInOutView)
        makerFadeInOutView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        makerFadeInOutView.clipsToBounds = false
        
        
    }
    
    func addSoundSpeedContainer() {
        let container = View()
        container.backgroundColor = .clear
        stackView.addArrangedSubview(container)
        container.snp.makeConstraints { (make) in
            make.height.equalTo(60)
        }
        
        container.addSubview(makerSoundAdjustView)
        makerSoundAdjustView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    func addControlContainer() {
        let container = View()
        container.backgroundColor = .clear
        stackView.addArrangedSubview(container)
        container.snp.makeConstraints { (make) in
            make.height.equalTo(90)
        }
        
        container.addSubview(makerControlView)
        
        makerControlView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func addMakerView() {
        
        makerView = RingmakerView.init()
        makerView.delegate = self
        makerViewContainer.addSubview(makerView)
        
        makerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        //Add label
        makerViewContainer.addSubview(startTimeLabel)
        startTimeLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        
        makerViewContainer.addSubview(endTimeLabel)
        endTimeLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        
        
    }
    
}

//MARK:- Extensition
extension RingMakerViewController: RingmakerDelegate {
    
    func makerDidUpdateStartTime(startTime: Double, endTime: Double) {
        self.startTimeLabel.text = startTime.toMS()
        self.endTimeLabel.text = endTime.toMS()
    }
    
    func makerDidChange(startTrimTime: Double, trimDuration: Double) {
        log.debug("-->\(startTrimTime)  - \(trimDuration)")
        subjectStartTrimTime.onNext(startTrimTime)
        subjectTrimDuration.onNext(trimDuration)
    }
}
