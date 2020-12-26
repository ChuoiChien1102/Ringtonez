//
//  LimitDurationView.swift
//  ringtoney
//
//  Created by dong ka on 15/11/2020.
//

import Foundation
import SnapKit

class LimitDurationView: View {
    
    let bag = DisposeBag.init()
    var limitDuration = BehaviorRelay<Double>.init(value: 20)
    
    var stackView = StackView().then {
        $0.spacing = 0
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        
    }
    

    var btn10sec : Button = Button().then {
        //Code here
        $0.setTitle("10s", for: .normal)
        $0.backgroundColor = UIColor.init(hexString: "252B43")
        $0.alpha = 1
    }
    
    var btn20sec: Button = Button().then {
        //Code here
        $0.setTitle("20s", for: .normal)
        $0.backgroundColor = UIColor.init(hexString: "252B43")
        $0.alpha = 1
    }
    
    var btn30sec: Button = Button().then {
        //Code here
        $0.setTitle("30s", for: .normal)
        $0.backgroundColor = UIColor.init(hexString: "252B43")
        $0.alpha = 1
    }
    
    var btn40sec: Button = Button().then {
        //Code here
        $0.setTitle("40s", for: .normal)
        $0.backgroundColor = UIColor.init(hexString: "252B43")
        $0.alpha = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateLayoutButton(btn10sec)
        updateLayoutButton(btn20sec)
        updateLayoutButton(btn30sec)
        updateLayoutButton(btn40sec)

        
    }

    override func makeUI() {
        super.makeUI()
//        self.backgroundColor = .white
        addStackView()
        addButton()
        
        let btnArray = [btn10sec,btn20sec,btn30sec,btn40sec]
        
        limitDuration.subscribe(onNext:{[weak self] seconds in
            
            for (index, button) in btnArray.enumerated() {
                if index == (Int(seconds / 10) - 1) {
                    button.backgroundColor = UIColor.white
                    button.setTitleColor(UIColor.init(hexString: "002417"), for: .normal)
                } else {
                    button.backgroundColor = UIColor.init(hexString: "252B43")
                    button.setTitleColor(UIColor.init(hexString: "ffffff"), for: .normal)

                }
            }
            
        })
        .disposed(by: bag)
        
    }
    
    func addStackView() {
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    
    func addButton() {
        wrapButton(btn10sec)
        wrapButton(btn20sec)
        wrapButton(btn30sec)
        wrapButton(btn40sec)

    }
    
    func wrapButton(_ btn: Button) {
        let container = View()
        stackView.addArrangedSubview(container)
        container.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        btn.titleLabel?.font = FontsManager.nasalization.font(size: 14)
    }
    
    func updateLayoutButton(_ btn: UIButton) {
        btn.layer.cornerRadius = 25
        btn.layer.masksToBounds = true
    }
    
    
    
    
}
