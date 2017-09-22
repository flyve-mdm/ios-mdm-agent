/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * UserModel.swift is part of flyve-mdm-ios
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
import UIKit
/// User Class
class UserModel: NSObject, NSCoding {
    var firstName: String
    var lastName: String
    var language: String
    var emails: [EmailModel]
    var phones: [AnyObject]
    var phone: String
    var mobilePhone: String
    var phone2: String
    var administrativeNumber: String
    var picture: UIImage
    
    /// init method
    init(data: [String: AnyObject]) {
        
        let defaultValue = "not available"
        self.firstName = data["firstname"] as? String ?? ""
        self.lastName = data["lastname"] as? String ?? ""
        self.language = data["language"] as? String ?? ""
        self.phones = data["phones"] as? [AnyObject] ?? [AnyObject]()
        self.phone = data["phone"] as? String ?? defaultValue
        self.mobilePhone = data["mobilePhone"] as? String ?? defaultValue
        self.phone2 = data["phone2"] as? String ?? defaultValue
        self.administrativeNumber = data["administrativeNumber"] as? String ?? ""
        self.picture = data["picture"] as? UIImage ?? UIImage(named: "picture")!
        
        for (index, item) in self.phones.enumerated() {
            
            if index == 0 {
                self.phone = item["phone"] as? String ?? defaultValue
            }
            
            if index == 1 {
                self.mobilePhone = item["phone"] as? String ?? defaultValue
            }
            
            if index == 2 {
                self.phone2 = item["phone"] as? String ?? defaultValue
            }
        }
        
        var emailModel = [AnyObject]()
        if let arrEmails = data["emails"] as? [AnyObject] {
            
            for item in arrEmails {
                
                emailModel.append(EmailModel(data: item as? [String: AnyObject] ?? [String: AnyObject]()))
            }
            
        }
        
        self.emails = emailModel as? [EmailModel] ?? []
    }
    
    /// Decodifies the object
    required init(coder decoder: NSCoder) {
        self.firstName = decoder.decodeObject(forKey: "firstName") as? String ?? ""
        self.lastName = decoder.decodeObject(forKey: "lastName") as? String ?? ""
        self.language = decoder.decodeObject(forKey: "language") as? String ?? ""
        self.emails = decoder.decodeObject(forKey: "emails") as? [EmailModel] ?? []
        self.phones = decoder.decodeObject(forKey: "phones") as? [AnyObject] ?? []
        self.phone = decoder.decodeObject(forKey: "phone") as? String ?? ""
        self.mobilePhone = decoder.decodeObject(forKey: "mobilePhone") as? String ?? ""
        self.phone2 = decoder.decodeObject(forKey: "phone2") as? String ?? ""
        self.administrativeNumber = decoder.decodeObject(forKey: "administrativeNumber") as? String ?? ""
        self.picture = decoder.decodeObject(forKey: "picture") as? UIImage ?? UIImage(named: "picture")!
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(firstName, forKey: "firstName")
        coder.encode(lastName, forKey: "lastName")
        coder.encode(language, forKey: "language")
        coder.encode(emails, forKey: "emails")
        coder.encode(phones, forKey: "phones")
        coder.encode(phone, forKey: "phone")
        coder.encode(mobilePhone, forKey: "mobilePhone")
        coder.encode(phone2, forKey: "phone2")
        coder.encode(administrativeNumber, forKey: "administrativeNumber")
        coder.encode(picture, forKey: "picture")
    }
}
