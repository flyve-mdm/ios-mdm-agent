/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * EnrollModel.swift is part of flyve-mdm-ios
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

import Foundation
/// EnrollModel Class
class EnrollModel: NSObject, NSCoding {
    var invitationToken: String
    var serial: String
    var uuid: String
    var csr: String
    var firstname: String
    var lastname: String
    var version: String
    var type: String

    /// init method
    init(data: [String: AnyObject]) {
        
        self.invitationToken = data["_invitation_token"] as? String ?? ""
        self.serial = data["_serial"] as? String ?? ""
        self.uuid = data["_uuid"] as? String ?? ""
        self.csr = data["csr"] as? String ?? ""
        self.firstname = data["firstname"] as? String ?? ""
        self.lastname = data["lastname"] as? String ?? ""
        self.version = data["version"] as? String ?? ""
        self.type = data["type"] as? String ?? "apple"
    }
    
    /// Decodifies the object
    required init(coder decoder: NSCoder) {
        self.invitationToken = decoder.decodeObject(forKey: "invitationToken") as? String ?? ""
        self.serial = decoder.decodeObject(forKey: "serial") as? String ?? ""
        self.uuid = decoder.decodeObject(forKey: "uuid") as? String ?? ""
        self.csr = decoder.decodeObject(forKey: "csr") as? String ?? ""
        self.firstname = decoder.decodeObject(forKey: "firstname") as? String ?? ""
        self.lastname = decoder.decodeObject(forKey: "lastname") as? String ?? ""
        self.version = decoder.decodeObject(forKey: "version") as? String ?? ""
        self.type = decoder.decodeObject(forKey: "type") as? String ?? "apple"
    }
    
    /// Codifies the object    
    func encode(with coder: NSCoder) {
        coder.encode(invitationToken, forKey: "invitationToken")
        coder.encode(serial, forKey: "serial")
        coder.encode(uuid, forKey: "uuid")
        coder.encode(csr, forKey: "csr")
        coder.encode(firstname, forKey: "firstname")
        coder.encode(lastname, forKey: "lastname")
        coder.encode(version, forKey: "version")
        coder.encode(type, forKey: "type")
    }
}

/// DeepLinkModel Class
class DeepLinkModel: NSObject, NSCoding {
    var url: String
    var userToken: String
    var invitationToken: String
    
    /// init method
    init(data: [String: AnyObject]) {
        
        self.url = data["url"] as? String ?? ""
        self.userToken = data["user_token"] as? String ?? ""
        self.invitationToken = data["invitation_token"] as? String ?? ""
    }
    
    /// Decodifies the object
    required init(coder decoder: NSCoder) {
        self.url = decoder.decodeObject(forKey: "url") as? String ?? ""
        self.userToken = decoder.decodeObject(forKey: "userToken") as? String ?? ""
        self.invitationToken = decoder.decodeObject(forKey: "invitationToken") as? String ?? ""
    }

    /// Codifies the object
    func encode(with coder: NSCoder) {
        coder.encode(url, forKey: "url")
        coder.encode(userToken, forKey: "userToken")
        coder.encode(invitationToken, forKey: "invitationToken")
    }
}
