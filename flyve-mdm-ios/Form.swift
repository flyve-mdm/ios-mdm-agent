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
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-agent
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit

/// Form class
public class Form {
    
    // MARK: Properties
    
    /// form's title
    var title: String
    /// this array contain the sections in the form
    var sections: [FormSection] = []
    
    // MARK: Init
    
    /**
     Init method in the class
     
     - parameter delay: form's title (optional)
     */
    init(title: String = "") {
        self.title = title
    }
    
    // MARK: Public
    
    /**
     Get all values in form
     
     - return: All values in form
     */
    func formValues() -> [String : AnyObject] {
        
        var formValues: [String : AnyObject] = [:]
        
        for section in sections {
            for row in section.rows {
                if let value = row.value {
                    formValues[row.tag] = value
                } else {
                    formValues[row.tag] = NSNull()
                }
            }
        }
        return formValues
    }
    
    /**
     Validate required fields
     
     - return: `FormRow` when field required and it's nil
     */
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
