/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * UserViewModel.swift is part of flyve-mdm-ios
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

class UserViewModel {
    private let user: UserModel
    
    var firstName: String {
        return user.firstName
    }
    
    var lastName: String {
        return user.lastName
    }
    
    var fullName: String {
        return "\(user.firstName) \(user.lastName)"
    }
    
    var language: String {
        return user.language
    }
    
    var emails: [AnyObject] {
        return user.emails
    }
    
    var phone: String {
        return user.phone
    }
    
    var mobilePhone: String {
        return user.mobilePhone
    }
    
    var phone2: String {
        return user.phone2
    }
    
    var administrativeNumber: String {
        return user.administrativeNumber
    }
    
    var picture: UIImage {
        return user.picture
    }
    
    init(user: UserModel) {
        self.user = user
    }
}
