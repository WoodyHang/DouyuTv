//
//  AppDelegate.swift
//  DYZB
//
//  Created by 1 on 16/9/12.
//  Copyright © 2016年 小码哥. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var allowRotation = 0

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UITabBar.appearance().tintColor = UIColor.orange
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask{
        if allowRotation == 1 {
            return [.landscapeRight,.portrait]
        }else {
            return .portrait
        }
    }
    
}

