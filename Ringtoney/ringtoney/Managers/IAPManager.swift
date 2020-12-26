//
//  IAPManager.swift
//  ringtoney
//
//  Created by dong ka on 30/11/2020.
//

import Foundation
import SwiftyUserDefaults

let IAP_OBSERVABLE = BehaviorRelay<Bool>.init(value: Defaults[\.isPurchased])

class IAPManager: NSObject {
    
    class func checkDownloadCounter() -> Bool {
        if Defaults[\.isPurchased] { return true }
        if Defaults[\.downloadCounter] <= 3 { Defaults[\.downloadCounter] += 1 }
        return Defaults[\.downloadCounter] <= 3
    }
    
    class func checkListentedCounter() -> Bool {
        if Defaults[\.isPurchased] { return true }
        if Defaults[\.listentCounter] <= 3 { Defaults[\.listentCounter] += 1 }
        return Defaults[\.listentCounter] <= 3
    }
    
    
}


class FlashSaleManager: NSObject {
    
    var timer: Timer?
    var counter = BehaviorRelay<Int>.init(value: Defaults[\.flashSaleCounter])
    
    static let shared = FlashSaleManager()
    
    func startTimer() {
        if Defaults[\.flashSaleCounter] > 0 {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (t) in
                self.counter.accept(self.counter.value - 1)
                Defaults[\.flashSaleCounter] = self.counter.value - 1
                if self.counter.value == 0 {
                    self.stopTimer()
                }
            })
        } else {
            Defaults[\.flashSaleCounter] = -1
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        self.counter.accept(0)
    }

}
