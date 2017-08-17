/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * SupervisorModel.swift is part of flyve-mdm-ios
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

/// SupervisorModel Class
class SupervisorModel {
    var name: String
    var email: String
    var phone: String
    var website: String
    var picture: String
    
    init(data: [String: AnyObject]) {
        let defaultValue = "not available"
        self.name = data["name"] as? String ?? defaultValue
        self.email = data["email"] as? String ?? defaultValue
        self.phone = data["phone"] as? String ?? defaultValue
        self.website = data["website"] as? String ?? defaultValue
        self.picture = data["picture"] as? String ?? defaultValue
    }
}
