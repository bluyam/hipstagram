//
//  AppDelegate.swift
//  Hipstagram
//
//  Created by Kyle Wilson on 2/24/16.
//  Copyright © 2016 Bluyam Inc. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var didPresentLogin: Bool?
    var window: UIWindow?
    var storyboard = UIStoryboard(name: "Main", bundle: nil)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        didPresentLogin = true
        
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
        // Override point for customization after application launch.
        // Initialize Parse
        // Set applicationId and server based on the values in the Heroku settings.
        // clientKey is not used on Parse open source unless explicitly configured
        Parse.initializeWithConfiguration(
            ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "Hipstagram"
                configuration.clientKey = "nfqh3495g0wperofhi34uur283rg"
                configuration.server = "https://evening-river-73373.herokuapp.com/parse"
            })
        )
        
        // check if user is logged in.
        if PFUser.currentUser() != nil {
            // if there is a logged in user then load the home view controller
            didPresentLogin = false
            let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as UIViewController
            
            window?.rootViewController = vc
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogout", name: "userDidLogoutNotification", object: nil)
        return true
    }
    
    func userDidLogout() {
        if didPresentLogin! {
            window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            let vc = storyboard.instantiateInitialViewController()
            window?.rootViewController = vc
        }
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

