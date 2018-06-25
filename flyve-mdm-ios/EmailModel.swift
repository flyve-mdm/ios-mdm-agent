/*
 * LICENSE
 *
 * EmailModel.swift is part of flyve-mdm-ios
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
 * @copyright Copyright © 2017-2018 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/ios-mdm-agent
 * @link      http://flyve.org/ios-mdm-agent
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import Foundation
/// EmailModel class
class EmailModel: NSObject, NSCoding {
    // MARK: Properties
    var type: String
    var email: String
    
    // MARK: Init
    /// init method
    init(data: [String: AnyObject]) {
        self.type = data["type"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
    }
    
    /// Decodifies the object
    required init(coder decoder: NSCoder) {
        self.type = decoder.decodeObject(forKey: "type") as? String ?? ""
        self.email = decoder.decodeObject(forKey: "email") as? String ?? ""
    }
    
    /// Codifies the object
    func encode(with coder: NSCoder) {
        coder.encode(type, forKey: "type")
        coder.encode(email, forKey: "email")
    }
}
