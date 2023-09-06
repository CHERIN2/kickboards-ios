//
//  AppDelegate.swift
//  kickboard
//
//  Created by 체린 on 9/4/23.
//

import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("Appdelegate")
    
        //MARK: - Add DummyData
        let isFirstLaunchKey: String = "isFirstLaunch"
        let isFirstLaunch = UserDefaults.standard.bool(forKey: isFirstLaunchKey)
        
        if !isFirstLaunch {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(dummyData), forKey: StorageManager.kickboardKey)
            UserDefaults.standard.set(true, forKey: isFirstLaunchKey)
        }

        //MARK: - Request User's Location
        GMSServices.provideAPIKey("AIzaSyA0QLhsa_4VYNSoX0tackGmZy5pdtwWjsk")
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

