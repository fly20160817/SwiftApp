//
//  AppDelegate.swift
//  SwiftApp
//
//  Created by fly on 2022/7/14.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //初始化第三方的SDK
        ConfigureSDK.initSDK(launchOptions: launchOptions)
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let tabVC = TabBarController()
        window?.rootViewController = tabVC

        return true
    }
    

}

