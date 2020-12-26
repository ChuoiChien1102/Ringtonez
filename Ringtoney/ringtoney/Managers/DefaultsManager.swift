//
//  DefaultsManager.swift
//  ringtoney
//
//  Created by dong ka on 10/29/20.
//

import Foundation
import SwiftyUserDefaults

//Define your key
extension DefaultsKeys {
    
    /*Launch count**/
    var launchCount: DefaultsKey<Int> { .init("launchCount", defaultValue: 0) }

    /*Purchased**/
    var isPurchased: DefaultsKey<Bool>{ .init("isPurchased", defaultValue: false) }
    
    /*listentCounter**/
    var listentCounter: DefaultsKey<Int>{ .init("listentCounter", defaultValue: 0) }
    
    /*downloadCounter**/
    var downloadCounter: DefaultsKey<Int>{ .init("downloadCounter", defaultValue: 0) }

    /*flashSaleCounter**/
    var flashSaleCounter: DefaultsKey<Int>{ .init("flashSaleCounter", defaultValue: Configs.DefaultValue.litmitOffer) }
    
    /*Flash sale date**/
    var startSaleDate: DefaultsKey<Date?>{ .init("startSaleDate", defaultValue: nil)}

}

func IS_PURCHASED() -> Bool {
    return Defaults[\.isPurchased]
}
