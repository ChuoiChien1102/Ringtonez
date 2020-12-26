//
//  ThemeManager.swift
//  ringtoney
//
//  Created by dong ka on 11/2/20.
//

import Foundation
import ChameleonFramework
import RxTheme

protocol Theme {
    var backgroundColor: UIColor { get }
    var textColor: UIColor { get }
}

struct LightTheme: Theme {
    let backgroundColor = UIColor.white
    let textColor = UIColor.black
}

struct DarkTheme: Theme {
    var backgroundColor: UIColor = UIColor.init(hexString: "191C2C")
    var textColor: UIColor = UIColor.init(hexString: "FFFFFF")
}

enum ThemeType: ThemeProvider {
    case light, dark
    var associatedObject: Theme {
        switch self {
        case .light:
            return LightTheme()
        case .dark:
            return DarkTheme()
        }
    }
}

let themeService = ThemeType.service(initial: .dark)
