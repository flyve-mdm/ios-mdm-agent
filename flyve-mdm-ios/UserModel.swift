/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * User.swift is part of flyve-mdm-ios
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
 * @date      17/08/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-agent
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit
/// User Class
class User {
    var firstName: String
    var lastName: String
    var language: String
    var emails: [Email]
    var phone: String
    var mobilePhone: String
    var phone2: String
    var administrativeNumber: String
    var picture: UIImage
    
    init(data: [String: AnyObject]) {
        
        self.firstName = data["firstname"] as? String ?? ""
        self.lastName = data["lastname"] as? String ?? ""
        self.language = data["language"] as? String ?? ""
        self.emails = data["emails"] as? [Email] ?? [Email]()
        self.phone = data["phone"] as? String ?? ""
        self.mobilePhone = data["mobilePhone"] as? String ?? ""
        self.phone2 = data["phone2"] as? String ?? ""
        self.administrativeNumber = data["administrativeNumber"] as? String ?? ""
        self.picture = data["picture"] as? UIImage ?? UIImage(named: "picture")!
    }
}
