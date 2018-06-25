/*
 * LICENSE
 *
 * UIColor+Helper.swift is part of flyve-mdm-ios
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
 * @author    Hector Rondon <hrondon@teclib.com>
 * @date      11/07/17
 * @copyright Copyright © 2017-2018 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/ios-mdm-agent
 * @link      http://flyve.org/ios-mdm-agent
 * @link      https://.flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit

extension UIColor {
    
    /**
     Main color
     
     - returns: main color for app
     */
    static let main: UIColor = {
        return UIColor.init(red: 26.0/255.0, green: 138.0/255.0, blue: 133.0/255.0, alpha: 1.0)
    }()

    /**
     Background color
     
     - returns: background color like group TableView for app
     */
    static let background: UIColor = {
        return .groupTableViewBackground
    }()
    
    /**
     Loading color
     
     - returns: background color for activity indicator
     */
    static let loading: UIColor = {
        return UIColor.init(red: 239.0/255.0, green: 62.0/255.0, blue: 54.0/255.0, alpha: 1.0)
    }()
    
    /**
     Fail color
     
     - returns: color for errors messages
     */
    static let fail: UIColor = {
        return UIColor.init(red: 111.0/255.0, green: 111.0/255.0, blue: 116.0/255.0, alpha: 1.0)
    }()
}
