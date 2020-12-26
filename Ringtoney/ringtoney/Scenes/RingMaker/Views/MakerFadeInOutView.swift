//
//  MakerFadeInOutView.swift
//  ringtoney
//
//  Created by dong ka on 16/11/2020.
//

import Foundation
import SnapKit

class MakerFadeInOutView: View {
    
    let bag = DisposeBag.init()
    
    var enableFadeIn = BehaviorRelay<Bool>.init(value: false)
    var enableFadeOut = BehaviorRelay<Bool>.init(value: false)

    let fadeinButton = Button().then {
        $0.setImage(R.image.icon_button_fadeIn(), for: .normal)
        $0.backgroundColor = UIColor.init(hexString: "00FFAA")
    }
    
    let fadeoutButton = Button().then {
        $0.setImage(R.image.icon_button_fadeOut(), for: .normal)
        $0.backgroundColor = UIColor.init(hexString: "252B43")
    }
    
    
    
    
    override func makeUI() {
        super.makeUI()
        
        addSubview(fadeinButton)
        fadeinButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(50)
        }
        
        
        addSubview(fadeoutButton)
        fadeoutButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(50)
        }
        
        enableFadeIn.subscribe(onNext:{[weak self] value in
            guard let self = self else { return }
            if value {
                self.fadeinButton.backgroundColor = UIColor.init(hexString: "00FFAA")
                self.fadeinButton.tintColor = UIColor.init(hexString: "002417")
                self.fadeinButton.layer.shadowColor = UIColor.init(hexString: "00FFAA")!.cgColor
            } else {
                self.fadeinButton.backgroundColor = UIColor.init(hexString: "252B43")
                self.fadeinButton.tintColor = UIColor.init(hexString: "ffffff")
                self.fadeinButton.layer.shadowColor = UIColor.clear.cgColor
            }
        })
        .disposed(by: bag)
        
        enableFadeOut.subscribe(onNext:{[weak self] value in
            guard let self = self else { return }
            if value {
                self.fadeoutButton.backgroundColor = UIColor.init(hexString: "00FFAA")
                self.fadeoutButton.tintColor = UIColor.init(hexString: "002417")
                self.fadeoutButton.layer.shadowColor = UIColor.init(hexString: "00FFAA")!.cgColor

            } else {
                self.fadeoutButton.backgroundColor = UIColor.init(hexString: "252B43")
                self.fadeoutButton.tintColor = UIColor.init(hexString: "ffffff")
                self.fadeoutButton.layer.shadowColor = UIColor.clear.cgColor

            }
        })
        .disposed(by: bag)
         
         
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUIButton(btn: fadeinButton)
        setUIButton(btn: fadeoutButton)


        
    }
    
    //Round button
    func setUIButton(btn: Button) {
        btn.layer.cornerRadius = 25
        btn.layer.masksToBounds = true
        
        btn.layer.shadowOffset = CGSize(width: 0, height: 0)
        btn.layer.shadowOpacity = 0.29
        btn.layer.shadowRadius = 20
        btn.layer.masksToBounds = false
        btn.layer.shadowColor = UIColor.clear.cgColor

    }
}
