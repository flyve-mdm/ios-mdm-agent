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
 * @copyright   Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios
 * @link      http://www.glpi-project.org/
 * ------------------------------------------------------------------------------
 */

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        loadMainView(userToken: "", invitationToken: "")
        
        return true
    }

    func loadMainView(userToken: String, invitationToken: String) {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = UINavigationController(rootViewController: ViewController(userToken: userToken, invitationToken: invitationToken))
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        var invitation = [String: AnyObject]()
        
//        let url = URL(string: "flyve://register?eyJ1cmwiOiJodHRwczovL2RlbW8uZmx5dmUub3JnL2dscGkvYXBpcmVzdC5waHAiLCJ1c2VyX3Rva2VuIjoieXVqOWVzOGE5MjVrNm04MnI1ZXpvMXRqdzN6ZjFxZTl4djJseWtuMiIsImludml0YXRpb25fdG9rZW4iOiI2Mjk1NWQyYzEzOTk2NDM1ZGIwMjYyNzBiNWQyMzUxNzNiZTY3NWQ3MTJlMDg4MmMyMmU4MjEzNDM3ZGQ1NDQ4In0=")
        
        guard let query = url.query else {
            
            loadMainView(userToken: "", invitationToken: "")
            return true
        }
        
        if let data = query.base64Decoded()?.data(using: .utf8) {
            do {
                invitation =  try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
            } catch {
                print(error.localizedDescription)
            }
        }
        
        guard let url_invitation: String = invitation["url"] as? String, let user_token: String = invitation["user_token"] as? String, let invitation_token: String = invitation["invitation_token"] as? String else {
            
            loadMainView(userToken: "", invitationToken: "")
            return true
        }

        baseURL = url_invitation

        loadMainView(userToken: user_token, invitationToken: invitation_token)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

