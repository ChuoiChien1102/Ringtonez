//
//  PremiumCModel.swift
//  ringtoney
//
//  Created by dong ka on 29/11/2020.
//

import Foundation
struct TheCPrice {
    var weekly: String = "then $4.99 per week, auto-renewable"
    var monthy: String = "then $12.99 per month, auto-renewable"
    var yearly: String = "$49.99 per year, auto-renewable"
}

enum PremiumChoisedState {
    case weekly, monthy, yearly
}

