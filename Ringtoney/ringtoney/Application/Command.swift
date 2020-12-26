//
//  Command.swift
//  ringtoney
//
//  Created by dong ka on 10/29/20.
//

import Foundation
import SwiftyBeaver
import SwiftRater;
import IHKeyboardAvoiding

let log = SwiftyBeaver.self

protocol Command {
    func execute()
}

struct InitializeThirdPartiesCommand: Command {
    func execute() {
        // Third parties are initialized here
        
        //Console logger
        let console = ConsoleDestination()
        console.format = "$DHH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M"
        log.addDestination(console)
        
        
        //SwiftRater
        SwiftRater.daysUntilPrompt = 7
        SwiftRater.usesUntilPrompt = 10
        SwiftRater.significantUsesUntilPrompt = 3
        SwiftRater.daysBeforeReminding = 1
        SwiftRater.showLaterButton = true
        SwiftRater.debugMode = false //Disable when release
        SwiftRater.appLaunched()
        
        //Keyboard
        KeyboardAvoiding.paddingForCurrentAvoidingView = 50.0
        
        //Database
        DatabaseManager.setup()
        
        //Create folder
        FCFileManager.createDirectories(forPath: Configs.FolderPath.ringtone)
        
        //IAP()
        Purchaser.completeTransactions {
            //Code
        }
        
        //
//        Defaults[\.]
        if Defaults[\.startSaleDate] == nil {
            Defaults[\.startSaleDate] = Date() //For first install
        }
        
        //SaleManager
        FlashSaleManager.shared.startTimer()
        
    }
}

struct AuthManagerCommand: Command {
    func execute() {
        
    }
}

struct InitializeAppearanceCommand: Command {
    func execute() {
        // Setup UIAppearance
        
        //Transparent UITabBar
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().barTintColor = UIColor.init(hexString: "191C2C")
        
    }
}

struct StartupConfigs: Command {
    func execute() {
        // Setup StartupConfigs
        
        Defaults[\.launchCount] += 1
        let launchCount = Defaults[\.launchCount]
        log.debug("Launch count: \(launchCount)")
        
    }
}

struct RegisterToRemoteNotificationsCommand: Command {
    func execute() {
        // Register for remote notifications here
        
        
        
        
    }
}
