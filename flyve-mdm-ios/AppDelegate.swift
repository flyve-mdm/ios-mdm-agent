/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * AppDelegate.swift is part of flyve-mdm-ios
 *
 * flyve-mdm-ios is a subproject of Flyve MDM. Flyve MDM is a mobile
 * device management software.
 *
 * flyve-mdm-ios is free software: you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 3
 * of the License, or (at your option) any later version.
 *
 * flyve-mdm-ios is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * ------------------------------------------------------------------------------
 * @author    Hector Rondon
 * @date      03/05/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-agent
 * @link      https://.flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit
import CoreLocation

/// class starting point of the application
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Properties
    
     /// This property contains the window used to present the app’s visual content on the device’s main screen.
    var window: UIWindow?
    
    /**
       CLLocationManager
     
       Discussion:
         The CLLocationManager object is your entry point to the location service.
     */
    let manager = CLLocationManager()
    
    // MARK: Methods
    
    /// Starting point of the application
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Enable lacation service
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .notDetermined {
                manager.requestAlwaysAuthorization()
                manager.requestWhenInUseAuthorization()
            }
        }

        if let mdmAgentData = getStorage(key: "mdmAgent") as? [String: AnyObject] {

            loadMainView(userToken: "", invitationToken: "", mdmAgent: mdmAgentData)

        } else {
            loadMainView(userToken: "", invitationToken: "")
        }

        return true
    }

    /// If the user is not registered, start the sign up screen otherwise go to the main screen
    func loadMainView(userToken: String, invitationToken: String, mdmAgent: [String: Any] = [String: Any]()) {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        if mdmAgent.count > 0 {
            window?.rootViewController = UINavigationController(rootViewController: MainController(mdmAgent: mdmAgent))
        } else {
            window?.rootViewController = UINavigationController(rootViewController: ViewController(userToken: userToken, invitationToken: invitationToken))
        }
    }

    /// Called when open the application from deeplink call
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

        if let mdmAgentData = getStorage(key: "mdmAgent") as? [String: AnyObject] {
            loadMainView(userToken: "", invitationToken: "", mdmAgent: mdmAgentData)
        }

        var invitation = [String: AnyObject]()
        guard let urlEnroll = URLComponents(string: url.absoluteString) else {
            loadMainView(userToken: "", invitationToken: "")
            return true
        }

        guard let query = urlEnroll.queryItems?.first(where: { $0.name == "data" })?.value else {
            loadMainView(userToken: "", invitationToken: "")
            return true
        }

        if let data = query.base64Decoded()?.data(using: .utf8) {
            do {
                invitation =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] ?? [String: AnyObject]()
            } catch {
                print(error.localizedDescription)
            }
        }

        guard invitation["url"] != nil, let user_token: String = invitation["user_token"] as? String, let invitation_token: String = invitation["invitation_token"] as? String else {
            loadMainView(userToken: "", invitationToken: "")
            return true
        }

        setStorage(value: invitation as AnyObject, key: "deeplink")
        loadMainView(userToken: user_token, invitationToken: invitation_token)

        return true
    }

    /// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    /// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    /// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    /// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    /// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    /// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    /// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}
