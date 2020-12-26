//
//  AppDelegate.swift
//  ringtoney
//
//  Created by dong ka on 10/29/20.
//

import UIKit
import SwiftyBeaver
//import FBSDKCoreKit
//import GoogleSignIn
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Initialize Facebook sign-in
//        ApplicationDelegate.shared.application( application,
//                                                didFinishLaunchingWithOptions: launchOptions )

        FirebaseApp.configure()
        
        StartupCommandsBuilder()
             .build()
             .forEach { $0.execute() }
                
        
        window = UIWindow()
        appCoordinator = AppCoordinator.init(window: window!)
        appCoordinator?.start()
        
        return true
    }

//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        let handledFB = FBSDKCoreKit.ApplicationDelegate.shared.application(app, open: url, options: options)
//        let handledGoogle = GIDSignIn.sharedInstance().handle(url)
//        return handledFB || handledGoogle
//    }
    
    /// set orientations you want to be allowed in this property by default
    var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }
    
}
