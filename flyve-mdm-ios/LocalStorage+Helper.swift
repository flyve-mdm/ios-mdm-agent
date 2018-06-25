/*
 * LICENSE
 *
 * LocalStorage.swift is part of flyve-mdm-ios
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
 * @date      13/07/17
 * @copyright Copyright © 2017-2018 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/ios-mdm-agent
 * @link      http://flyve.org/ios-mdm-agent
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import Foundation

/**
 Get AnyObject from local storage
 
 - parameter key: key value
 - return: key value as AnyObject stored in UserDefaults
 */
public func getStorage(key: String) -> AnyObject? {

    if let obj = UserDefaults.standard.object(forKey: key) {
        return NSKeyedUnarchiver.unarchiveObject(with: obj as? Data ?? Data()) as AnyObject

    } else {
        return nil
    }
}

/**
 Save AnyObject in local storage
 
 - parameter key: key value
 */
public func setStorage(value: AnyObject, key: String) {

    let encodedData = NSKeyedArchiver.archivedData(withRootObject: value)
    UserDefaults.standard.set(encodedData, forKey: key)
    UserDefaults.standard.synchronize()
}

/**
 Remove all objects in local storage
 */
public func removeAllStorage() {
    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    UserDefaults.standard.synchronize()
}
