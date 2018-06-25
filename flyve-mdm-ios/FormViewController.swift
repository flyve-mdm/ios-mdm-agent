/*
 * LICENSE
 *
 * UserInfoController.swift is part of flyve-mdm-ios
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
 * @date      02/08/17
 * @copyright Copyright © 2017-2018 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/ios-mdm-agent
 * @link      http://flyve.org/ios-mdm-agent
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit

/// FormViewController class
class FormViewController: UITableViewController {
    
    // MARK: Class variables
    /// constant cell type
    private static var __once: () = {
        FormViewController.defaultCellClasses[.title] = FormTitleCell.self
        FormViewController.defaultCellClasses[.info] = FormInfoCell.self
        FormViewController.defaultCellClasses[.phone] = FormTextFieldSelectCell.self
        FormViewController.defaultCellClasses[.email] = FormTextFieldSelectCell.self
        FormViewController.defaultCellClasses[.text] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.number] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.password] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.multipleSelector] = FormSelectorCell.self
    }()
    /// `onceDefaultCellClass`
    fileprivate static var onceDefaultCellClass: Int = 0
    /// `defaultCellClasses`
    fileprivate static var defaultCellClasses: [FormRow.RowType : FormBaseCell.Type] = [:]
    
    // MARK: Properties
    /// `form`
    var form = Form()
    
    // MARK: Init
    /// convenience init method
    convenience init() {
        self.init(style: .grouped)
    }
    
    /// convenience init method whit `Form`
    convenience init(form: Form) {
        self.init(style: .grouped)
        self.form = form
    }
    
    /// override init method from super class
    override init(style: UITableViewStyle) {
        super.init(style: style)
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
    }
    
    /// override init method from super class
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /// override init method from super class
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // MARK: View life cycle
    /// override init method from super class, called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = form.title
    }
    
    // MARK: Public interface
    /**
     Get value for tag
     - return: value for tag as `AnyObject`
     */
    func valueForTag(_ tag: String) -> AnyObject? {
        for section in form.sections {
            for row in section.rows.filter({ $0.tag == tag}) {
                return row.value
            }
        }
        return nil
    }
    
    /**
     Set value for tag
     - return: update cell with new value
     */
    func setValue(_ value: AnyObject, forTag tag: String) {
        for (sectionIndex, section) in form.sections.enumerated() {
            for (rowIndex, row) in section.rows.enumerated() where row.tag == tag {
                form.sections[sectionIndex].rows[rowIndex].value = value
                if let cell = self.tableView.cellForRow(at: IndexPath(row: rowIndex, section: sectionIndex)) as? FormBaseCell {
                    cell.update()
                }
                return
            }
        }
    }
    
    // MARK: UITableViewDataSource

    /**
     override `numberOfSections` from super class, get number of sections in UITableView
     
     - return: number of sections in UITableView
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return form.sections.count
    }
    
    /**
     override `numberOfRowsInSection` from super class, get number of row in sections
     
     - return: number of row in sections
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.sections[section].rows.count
    }
    
    /**
     override `cellForRowAt` from super class, Asks the data source for a cell to insert in a particular location of the table view
     
     - return: `UITableViewCell`
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = formRowAtIndexPath(indexPath)
        
        let formBaseCellClass = formBaseCellClassFromRow(row)
        
        let reuseIdentifier = NSStringFromClass(formBaseCellClass!)
        
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? FormBaseCell
        if cell == nil {
            cell = formBaseCellClass?.init(style: .default, reuseIdentifier: reuseIdentifier)
            cell?.formViewController = self
            cell?.configure()
        }
        
        cell?.row = row
        
        // apply cell custom design
        for (keyPath, value) in row.configuration.cell.appearance {
            cell?.setValue(value, forKeyPath: keyPath)
        }
        return cell!
    }
    
    /**
     override `heightForHeaderInSection` from super class, set number of row in sections
     
     - return: height for header in section
     */
    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return form.sections[section].headerTitle
    }
    
    /**
     override `titleForFooterInSection` from super class
     
     - return: title in footer section
     */
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return form.sections[section].footerTitle
    }
    
    /**
     override `viewForFooterInSection` from super class
     
     - return: view in footer section
     */
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let headerView = form.sections[section].headerView else { return nil }
        return headerView
    }
    
    /**
     override `viewForHeaderInSection` from super class
     
     - return: view in header section
     */
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let footerView = form.sections[section].footerView else { return nil }
        return footerView
    }
    
    /**
     override `heightForHeaderInSection` from super class
     
     - return: height in header section
     */
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let headerView = form.sections[section].headerView, headerView.translatesAutoresizingMaskIntoConstraints else {
            return form.sections[section].headerViewHeight
        }
        return headerView.frame.size.height
    }
    
    /**
     override `heightForFooterInSection` from super class
     
     - return: height in footer section
     */
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let footerView = form.sections[section].footerView, footerView.translatesAutoresizingMaskIntoConstraints else {
            return form.sections[section].footerViewHeight
        }
        return footerView.frame.size.height
    }
    
    // MARK: UITableViewDelegate
    /**
     override `canEditRowAt` from super class
     Asks the data source to verify that the given row is editable.
     - return: Bool
     */
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /**
     override `shouldIndentWhileEditingRowAt` from super class
     Asks the delegate whether the background of the specified row should be indented while the table view is in editing mode.
     - return: Bool
     */
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    /**
     override `editingStyleForRowAt` from super class
     Asks the delegate for the editing style of a row at a particular location in a table view.
     - return: The editing control used by a cell.
     */
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        let row = formRowAtIndexPath(indexPath)
        return row.edit
    }
    
    /**
     override `editingStyle` from super class
     remove cell when UITableViewCellEditingStyle is .delete
     */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            form.sections[indexPath.section].rows.remove(at: indexPath.row)

            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    /**
     override `didSelectRowAt` from super class
     Tells the delegate that the specified row is now selected.
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = formRowAtIndexPath(indexPath)
        
        if let selectedRow = tableView.cellForRow(at: indexPath) as? FormBaseCell {
            if let formBaseCellClass = formBaseCellClassFromRow(row) {
                formBaseCellClass.formViewController(self, didSelectRow: selectedRow)
            }
        }
        
        if let didSelectClosure = row.configuration.button.didSelectClosure {
            didSelectClosure(row)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /**
     - return: `FormBaseCell` type
     */
    fileprivate class func defaultCellClassForRowType(_ rowType: FormRow.RowType) -> FormBaseCell.Type {
        _ = FormViewController.__once
        return FormViewController.defaultCellClasses[rowType]!
    }
    
    /**
     - return: `FormRow`
     */
    fileprivate func formRowAtIndexPath(_ indexPath: IndexPath) -> FormRow {
        
        let section = form.sections[(indexPath as NSIndexPath).section]
        let row = section.rows[(indexPath as NSIndexPath).row]
        return row
    }
    
    /**
     - return: `FormBaseCell` type
     */
    fileprivate func formBaseCellClassFromRow(_ row: FormRow) -> FormBaseCell.Type! {
        
        var formBaseCellClass: FormBaseCell.Type
        
        if let cellClass = row.configuration.cell.cellClass as? FormBaseCell.Type {
            formBaseCellClass = cellClass
        } else {
            formBaseCellClass = FormViewController.defaultCellClassForRowType(row.type)
        }
        return formBaseCellClass
    }
}
