/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * Form.swift is part of flyve-mdm-ios
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
 * @date      03/08/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit

class Form {
    
    // MARK: Properties
    
    var title: String
    var sections: [FormSection] = []
    
    // MARK: Init
    
    init() {
        self.title = ""
    }
    
    init(title: String) {
        self.title = title
    }
    
    // MARK: Public
    
    func formValues() -> [String : AnyObject] {
        
        var formValues: [String : AnyObject] = [:]
        
        for section in sections {
            for row in section.rows {
                if row.type != .button {
                    if let value = row.value {
                        formValues[row.tag] = value
                    } else {
                        formValues[row.tag] = NSNull()
                    }
                }
            }
        }
        return formValues
    }
    
    func validateForm() -> FormRow? {
        for section in sections {
            for row in section.rows {
                if row.configuration.cell.required && row.value == nil {
                    return row
                }
            }
        }
        return nil
    }
}
