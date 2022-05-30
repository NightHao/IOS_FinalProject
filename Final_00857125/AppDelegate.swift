//
//  AppDelegate.swift
//  Final_00857125
//
//  Created by nighthao on 2022/5/28.
//

import UIKit
import Firebase
import FacebookCore
import GoogleSignIn
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
}
