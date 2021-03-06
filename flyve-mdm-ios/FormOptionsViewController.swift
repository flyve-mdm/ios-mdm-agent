/*
 * LICENSE
 *
 * FormOptionsSelectorController.swift is part of flyve-mdm-ios
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
 * @date      05/08/17
 * @copyright Copyright © 2017-2018 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/ios-mdm-agent
 * @link      http://flyve.org/ios-mdm-agent
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit

/// FormOptionsSelectorController class
open class FormOptionsSelectorController: UITableViewController, FormSelector {
    
    // MARK: FormSelector
    /// FormBaseCell
    open var formCell: FormBaseCell?
    
    // MARK: Init
    /// override method init from super class
    public init() {
        super.init(style: .grouped)
    }
    
    /// override method init from super class
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    /// override method init from super class
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /// override method `viewDidLoad()` from super class
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = formCell?.row?.title
    }
    
    // MARK: UITableViewDataSource
    /**
     override `numberOfSections` from super class, get number of sections in UITableView
     
     - return: number of sections in UITableView
     */
    open override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /**
     override `numberOfRowsInSection` from super class, get number of row in sections
     
     - return: number of row in sections
     */
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let options = formCell?.row?.configuration.selection.options, !options.isEmpty else { return 0 }
        return options.count
    }
    
    /**
     override `heightForHeaderInSection` from super class, get number of row in sections
     
     - return: height for header in section
     */
    open override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    /**
     override `cellForRowAt` from super class, Asks the data source for a cell to insert in a particular location of the table view
     
     - return: `UITableViewCell`
     */
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = NSStringFromClass(type(of: self))
        
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        
        let options = formCell!.row!.configuration.selection.options
        let optionValue = options[(indexPath as NSIndexPath).row]
        
        cell?.textLabel?.text = formCell?.row?.configuration.selection.optionTitleClosure?(optionValue)
        cell?.textLabel?.textColor = .gray
        cell?.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        
        if let selectedOptions = formCell?.row?.option as? [AnyObject] {
            if (selectedOptions.index(where: { $0 === optionValue })) != nil {
                cell?.accessoryType = .checkmark
            } else {
                cell?.accessoryType = .none
            }
            
        } else if let selectedOption = formCell?.row?.option {
            if optionValue === selectedOption {
                cell?.accessoryType = .checkmark
            } else {
                cell?.accessoryType = .none
            }
        }

        return cell!
    }
    
    // MARK: UITableViewDelegate
    /**
     override `didSelectRowAt` from super class, tells the delegate that the specified row is now selected
     */
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        var allowsMultipleSelection = false
        if let allowsMultipleSelectionValue = formCell?.row?.configuration.selection.allowsMultipleSelection {
            allowsMultipleSelection = allowsMultipleSelectionValue
        }
        
        let options = formCell!.row!.configuration.selection.options
        let selectedOption = options[(indexPath as NSIndexPath).row]
        
        if allowsMultipleSelection {
            if var selectedOptions = formCell?.row?.option as? [AnyObject] {
                if let index = selectedOptions.index(where: { $0 === selectedOption }) {
                    selectedOptions.remove(at: index)
                    cell?.accessoryType = .none
                } else {
                    selectedOptions.append(selectedOption)
                    cell?.accessoryType = .checkmark
                }
                formCell?.row?.option = selectedOptions as AnyObject
                
            } else {
                formCell?.row?.option = [AnyObject](arrayLiteral: selectedOption) as AnyObject
                cell?.accessoryType = .checkmark
            }

        } else {
            formCell?.row?.option = selectedOption
        }
        
        formCell?.update()
        
        if allowsMultipleSelection {
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}
