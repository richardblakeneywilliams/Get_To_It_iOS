//
//  AppDelegate.swift
//  Get_To_It_iOS
//
//  Created by Richard Blakeney-Williams on 21/04/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleMaps
import ChameleonFramework


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let themeColour = UIColor(red:0.28, green:0.67, blue:0.89, alpha:1.0)
        
    //TODO: Add offline check into this later like System Prefs 
    internal var LoggedIn: Bool{
        get {
            var loggedIn:Bool
            if (FIRAuth.auth()?.currentUser) != nil {
                // User is signed in.
                loggedIn = true
            } else {
                // No user is signed in.
                loggedIn = false
            }
            return loggedIn
        }
    }
    
    func showMainTabScreen(){
        // Get login screen from storyboard and present it
        //print("showTabScreen")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: MainTabViewController = (storyboard.instantiateViewController(withIdentifier: "mainTabbedScreen") as! MainTabViewController)
        self.window!.makeKeyAndVisible()
        self.window!.rootViewController!.present(viewController, animated: false, completion: nil)
    }
    
    func showLoginScreen(){
        // Get login screen from storyboard and present it
        //print("showLoginScreen")
        let storyboard = UIStoryboard(name: "Sign-In:Create Account", bundle: nil)
        let viewController: LoginViewController = (storyboard.instantiateViewController(withIdentifier: "loginScreen") as! LoginViewController)
        self.window!.makeKeyAndVisible()
        self.window!.rootViewController!.present(viewController, animated: true, completion: nil)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Chameleon.setGlobalThemeUsingPrimaryColor(FlatSkyBlue(), withContentStyle: .Light)

        //NexmoClient.start(applicationId: NEXMO_KEY , sharedSecretKey: NEXMO_SECRET)
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GMSServices.provideAPIKey(Maps_API_Key)
        if(LoggedIn){
            DispatchQueue.main.async{
                self.showMainTabScreen()
                //print("Going to main tab screen from app delegate")
            }
        } else {
            DispatchQueue.main.async{
                self.showLoginScreen()
                //print("Going to login screen from app delegate")
            }
        }
        return true
    }
    
    
    func application(_ application: UIApplication, open url: URL,
                     sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance()
            .application(application, open: url,
                         sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //To track app opens
        //FBSDKAppEvents.activateApp()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
    }
    
}
