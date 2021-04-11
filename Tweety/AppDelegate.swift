//
//  AppDelegate.swift
//  Tweety
//
//  Created by Himanshu Arora on 11/04/21.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        initializeWindow()
        return true
    }
    
    func initializeWindow(){
        let tabController = ViewController()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabController
        window?.makeKeyAndVisible()
    }
    
}
